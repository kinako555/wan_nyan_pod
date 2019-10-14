$(function() {

    let selected_pictures_length = 0;

    // 新規作成

    $('.open_new_micropost').on('click', function() {
        $('#modal_new_micropost').modal(); // modal表示
    });

    $('#micropost_pictures').on('change',function(e) {
        const ERROR_MSG = '5MB以下のファイルを選択してください。';
        let files = e.target.files;
        let def = (new $.Deferred()).resolve();
        // 画像ファイルサイズチェック
        if (!isCheckSizeMb(files)) {
            alert(ERROR_MSG);
            return false;
        }
        
        if (!isCheckPicturesLength(selected_pictures_length + files.length)) {
            alert('画像は4枚まで選択できます。');
            return false;
        }
        selected_pictures_length += files.length;
        formatModalSize(selected_pictures_length);
        $.each(files,function(i,file){      
            def = def.then(function(){return previewPicture(file)});
        });
    })

    function isCheckSizeMb(files) {
        $.each(files,function(i,file){
            let sizeInMb = file.size/1024/1024;
            if (sizeInMb > 5) return false;
        });
        return true;
    }

    function isCheckPicturesLength(length) {
        return (length <= 4 ? true : false);
    }

    // 選択画像枚数に合わせてモーダルサイズを調整
    function formatModalSize(length) {
        const DEFAULT_HEIGHT = length * 250 + 498;
        $('.modal-content').css('height', DEFAULT_HEIGHT + 'px')
    }

    function previewPicture(imageFile) {
        let reader = new FileReader();
        let img = new Image();
        let def =$.Deferred();
        reader.onload = function(e){
            $('.pictures_field').append(img);
            img.src = e.target.result;
            def.resolve(img);
        };
        reader.readAsDataURL(imageFile);
        return def.promise();
    }

    // 一覧

    const FAVORITE_SUBMIT_ID_FIRST = '#favorite_micropost_submit-';
    const SHARE_SUBMIT_ID_FIRST =    '#share_micropost_submit-';

    $(document).on('click', '.favorite_micropost_icon', function() {
        $(FAVORITE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.unfavorite_micropost_icon', function() {
        $(FAVORITE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.share_micropost_icon', function() {
        $(SHARE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.unshare_micropost_icon', function() {
        $(SHARE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

});