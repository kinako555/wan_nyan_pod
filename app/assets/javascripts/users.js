$(window).on('load', function () {
    // cropper（トリミング部）のコーディング（詳しくはGitHub参照
    let cropper;
    let croppable = false;
    function initIconCrop(){
      cropper = new Cropper(crop_img, {
        dragMode:         'move', //ドラッグの際にcanvasを動かす
        aspectRatio:      1,      //アクセプト比率
        restore:          false,  //ウィンドウのサイズ変更の際、トリミング領域を戻す
        guides:           false,  //トリミング領域に破線を表示する
        highlight:        false,  //トリミングボックスを強調表示する
        center:           false,  //真ん中に+印を表示する
        cropBoxMovable:   false,  //ドラッグでCropBoxを動かす
        cropBoxResizable: false,  //ドラッグでCropBoxのサイズを戻す
        toggleDragModeOnDblclick: false, //ダブルクリックでドラッグモードの切り替えをする
        minCropBoxWidth:  200,
        minCropBoxHeight: 200,
        ready: function(){
          croppable = true;
        }
      });
    }
    
    // croppedCanvas（トリミング後の画像をプレビューとして表示するための部分）
    // のコーディング
    let croppedCanvas;
    function iconCropping(){
      if(!croppable){
        alert('トリミングする画像が設定されていません。');
        return false;
      }
      croppedCanvas = cropper.getCroppedCanvas({
        width:  200,
        height: 200,
      });
      let croppedImage = document.createElement('img');
      croppedImage.src = croppedCanvas.toDataURL();
      img_field.innerHTML = '';
      img_field.appendChild(croppedImage);
    };

    // blobへ変換するためのコーディング（blobという形式で画像データを保存するため）
    let blob;
    function blobing(){
      if (croppedCanvas && croppedCanvas.toBlob){
        //  if ~.toBlob -> HTMLCanvasElement.toBlob() が使用できる場合
        croppedCanvas.toBlob(function(b){
          blob = b;     
        });
      }else if(croppedCanvas && croppedCanvas.msToBlob){
        // msToblob -> IE10以降やEDGEで使えるメソッド
        blob = croppedCanvas.msToBlob();
      }else{
        blob = null;
      }
    };

    // 入力されたformデータ（textやradioなど）を取得する関数作成
    function usersVal(formData){
      name = $('#user_name').val();
      email = $('#user_email').val();
      password = $('#user_password').val();
      password_confirmation = $('#user_password_confirmation').val();
  
      if (blob != null) formData.append('icon', blob);
      formData.append('name', name);
      formData.append('email', email);
      formData.append('password', password);
      formData.append('password_confirmation', password_confirmation);

      return formData
    }

    // formデータをまとめてajaxでコントローラーに渡すための準備
    function sending(){
      var formData = new FormData();
      const id = $('#idParams').val();
  
      // CSRF対策（独自のajax処理を行う場合、head内にあるcsrf-tokenを取得して送る必要がある）
      $.ajaxPrefilter(function(options, originalOptions, jqXHR){
        var token;
        if (!options.crossDomain){
          token = $('meta[name="csrf-token"]').attr('content');
  
          if (token){
            return jqXHR.setRequestHeader('X-CSRF-Token', token);
          };
        };
      });
      // 入力されたformデータをformDataに入れる
      usersVal(formData);

      $.ajax({
        url:         '/users/' + id,
        datatype:    'json',
        type:        'patch',
        data:        formData,
        processData: false,
        contentType: false,
      });
    };

    // 画像選択時
    $('#icon').on('change', function(e){
      file = e.target.files[0];
      reader = new FileReader();
  
      // 選択されたファイルの確認
      if(!file || file.type.indexOf('image') < 0) return false;
      $('#modal-img').modal(); // modal表示
      // トリミング画面をフェードインさせる
      reader.onload = (function(e){
        $('.crop_view').append($('<img>').attr({
          src: e.target.result,
          class: "preview",
          id: "crop_img",
          title: file.name
        }));
        initIconCrop();
      });
      // Cropper.jsが読み込めるようにBase64データとして取得
      reader.readAsDataURL(file);
      $(this).val(''); //同じファイルを検知するためにvalueを削除
    });
  
    // トリミング決定時
    $('.select_icon_btn').on('click', function(){
      iconCropping();
      //$('.overlay').fadeOut();
      $('#crop_img').remove();
      $('.cropper-container').remove();
      blobing();
    });
  
    // トリミング画面を閉じる時
    $('.close_btn').on('click', function(){
      //$('.overlay').fadeOut();
      $('#crop_img').remove();
      $('.cropper-container').remove();
    });

    // サーバーへ送信
    $('.submit_btn').on('click', function(){
      sending();
    });
});