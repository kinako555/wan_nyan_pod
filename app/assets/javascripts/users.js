$(function(){
  // cropper（トリミング部）のコーディング（詳しくはGitHub参照）
  let cropper;
  let croppable = false;
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
      minCropBoxWidth: 200,
      minCropBoxHeight: 200,
      ready: function(){
        croppable = true;
      }
    });
  }

  // croppedCanvas（トリミング後の画像をプレビューとして表示するための部分）のコーディング
  let croppedCanvas;
  function iconCropping(){
    if (!croppable) {
      alert('トリミングする画像が設定されていません。');
      return false;
    }
    croppedCanvas = cropper.getCroppedCanvas({
      width: 200,
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

  // 画像選択時
  $('#icon').on('change', function(e){
    file = e.target.files[0];
    reader = new FileReader();

    // 選択されたファイルの確認
    if(!file || file.type.indexOf('image') < 0) return false;
    
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
    //$(this).val(''); //同じファイルを検知するためにvalueを削除
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
});