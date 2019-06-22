// IconUploader

$(function(){
    // cropper（トリミング部）のコーディング（詳しくはGitHub参照）
    var cropper;
    var croppable = false;
    function initIconCrop(){
      cropper = new Cropper(crop_img, {
        dragMode: 'move',
        aspectRatio: 1,
        restore: false,
        guides: false,
        center: false,
        highlight: false,
        cropBoxMovable: false,
        cropBoxResizable: false,
        minCropBoxWidth: 280,
        minCropBoxHeight: 280,
        ready: function(){
          croppable = true;
        }
      });
    }
  
    // croppedCanvas（トリミング後の画像をプレビューとして表示するための部分）のコーディング
    var croppedCanvas;
    function iconCropping(){
      if (!croppable) {
        alert('トリミングする画像が設定されていません。');
        return false;
      }
      croppedCanvas = cropper.getCroppedCanvas({
        width: 280,
        height: 280,
      });
      var croppedImage = document.createElement('img');
      croppedImage.src = croppedCanvas.toDataURL();
      img_field.innerHTML = '';
      img_field.appendChild(croppedImage);
    };
  
   // blobへ変換するためのコーディング（blobという形式で画像データを保存するため）
    var blob;
    function blobing(){
      if (croppedCanvas && croppedCanvas.toBlob){
        croppedCanvas.toBlob(function(b){
          blob = b;
          sending();
        });
      }else if(croppedCanvas && croppedCanvas.msToBlob){
        blob = croppedCanvas.msToBlob();
        sending();
      }else{
        blob = null;
        sending();
      };
    };
  
    // formデータをまとめてajaxでコントローラーに渡すための準備
    function sending(){
      var formData = new FormData();
      const route = $('#route').val();
      const id = $('#idParams').val();
      const action = $('#action').val();
  
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
  
      // newとeditでルーティングを区別
      if (action == "new"){
        $.ajax({
          url: '/' + route,
          datatype: 'json',
          type: 'post',
          data: formData,
          processData: false,
          contentType: false,
        });
      }else if (action == "edit"){
        $.ajax({
          url: '/' + route + '/' + id,
          datatype: 'json',
          type: 'patch',
          data: formData,
          processData: false,
          contentType: false,
        });
      }
    };
  
    // 入力されたformデータ（textやradioなど）を取得する関数作成
    function usersVal(formData){
      name = $('#name').val();
      email = $('#email').val();
      twitter = $('#twitter').val();
      facebook = $('#facebook').val();
      content = $('#content').val();
      want_to_advertise = $(':radio[name="want_to_advertise"]:checked').val();
      want_to_be_advertised = $(':radio[name="want_to_be_advertised"]:checked').val();
  
      if (blob != null){
        formData.append('icon', blob);
      }
      formData.append('name', name);
      formData.append('email', email);
      formData.append('twitter', twitter);
      formData.append('facebook', facebook);
      formData.append('content', content);
      if (want_to_advertise != null){
        formData.append('want_to_advertise', want_to_advertise);
      }
      if (want_to_be_advertised != null){
        formData.append('want_to_be_advertised', want_to_be_advertised);
      }
      return formData
    }
  
    // 画像選択時
    $('#upicon').on('change', function(e){
      file = e.target.files[0];
      reader = new FileReader();
  
      if(file.type.indexOf('image') < 0){
        return false;
      };
      
      // トリミング画面をフェードインさせる
      reader.onload = (function(e){
        $('.overlay').fadeIn();
        $('.crop_modal').append($('<img>').attr({
          src: e.target.result,
          height: "100%",
          class: "preview",
          id: "crop_img",
          title: file.name
        }));
        initIconCrop();
      });
      reader.readAsDataURL(file);
    });
  
    // トリミング決定時
    $('.select_icon_btn').on('click', function(){
      iconCropping();
      $('.overlay').fadeOut();
      $('#crop_img').remove();
      $('.cropper-container').remove();
    });
  
    // トリミング画面を閉じる時
    $('.close_btn').on('click', function(){
      $('.overlay').fadeOut();
      $('#crop_img').remove();
      $('.cropper-container').remove();
    });
  
    // コントローラーへ送信
    $('.submit_btn').on('click', function(){
      blobing();
    });
  });