$(function() {

    // 新規作成

    let _selected_pictures_length = 0;
    let _selected_pictures = {};
    
    // 新規投稿モーダル表示
    $(document).on('click', '.open_new_micropost', function() {
        InitializeModal();
        $('#modal_new_micropost').modal(); // modal表示
    });

    // 添付ファイル選択
    $(document).on('change', '#micropost_pictures', function(e) {
        const FILES = e.target.files;
        let def = (new $.Deferred()).resolve();
        if (!isFilesCheck(FILES)) return false;        
        $.each(FILES,function(i,file){ 
            const TOKEN = createToken();
            _selected_pictures[TOKEN] = file;
            def = def.then(function(){return previewPicture(file, TOKEN)});
        });
        _selected_pictures_length += FILES.length;
        formatModalSize();
    })

    $(document).on('click', '.delete_picture', function() {
        const TOKEN = $(this).attr('id');
        _selected_pictures_length -= 1;
        $(this).parent().remove();
        delete _selected_pictures[TOKEN];
        formatModalSize();
    });

    // 投稿実行ボタン
    $(document).on('click', '.send_micropost_btn', function() {
        if (!isCheckSendValue()) {
            InitializeModal();
            return false;
        }
        let formData = new FormData();

        // CSRF対策（独自のajax処理を行う場合、head内にあるcsrf-tokenを取得して送る必要がある）
        $.ajaxPrefilter(function(options, originalOptions, jqXHR){
            let token;
            if (!options.crossDomain){
                token = $('meta[name="csrf-token"]').attr('content');
                if (token) return jqXHR.setRequestHeader('X-CSRF-Token', token);
            };
        });
        setFormData(formData);
        _selected_pictures_length = 0;
        _selected_pictures = {};
        $.ajax({
            url:         '/microposts',
            datatype:    'json',
            type:        'post',
            data:        formData,
            processData: false,
            async:       false,
            contentType: false
        })
    });

    // モーダルを閉じるボタン
    $(document).on('click', '.close_micropost_btn', function() {
        InitializeModal();
    });

    function setFormData(formData) {
        const CONTENT = $('#micropost_content').val();
        formData.append('content', CONTENT);
        for (let i=0; i < _selected_pictures_length; i++) {
            //pictures_* パラメータに画像ファイルをセットする
            formData.append('pictures_' + i, _selected_pictures[Object.keys(_selected_pictures)[i]]);
         }
        formData.append('pictures_length', _selected_pictures_length);

        return formData;
    }

    // モーダル初期化
    function InitializeModal() {
        _selected_pictures_length = 0;
        _selected_pictures = {};
        $('#micropost_content').val(null);
        $('#micropost_pictures').val(null);
        $(".pictures_field").empty();
        formatModalSize();
    }

    // 選択されたファイルのチェック
    function isFilesCheck(files) {
        if (!isCheckSizeMb(files)) {
            alert('5MB以下のファイルを選択してください。');
            return false;
        }
        if (!isCheckPicturesLength(files.length)) {
            alert('画像ファイルは4枚までです。');
            return false;
        }
        return true;
    }

    // 5MB以上のファイルは選択できない
    function isCheckSizeMb(files) {
        $.each(files,function(i,file){
            let sizeInMb = file.size/1024/1024;
            if (sizeInMb > 5) return false;
        });
        return true;
    }

    // 選択ファイル数は4枚以下まで
    function isCheckPicturesLength(length) {
        return (length + _selected_pictures_length <= 4 ? true : false);
    }

    function isCheckSendValue() {
        if (!$('#micropost_content').val()) {
            alert("文字が入力されていません。");
            return false;
        } 
        if (_selected_pictures_length <= 0) {
            alert("画像が選択されていません。");
            return false;
        }
        return true;
    }

    // 選択画像枚数に合わせてモーダルサイズを調整
    function formatModalSize() {
        const DEFAULT_HEIGHT = _selected_pictures_length * 250 + 498;
        $('.modal-content').css('height', DEFAULT_HEIGHT + 'px')
    }

    function previewPicture(imageFile, token) {
        let reader = new FileReader();
        let img = new Image();
        let def =$.Deferred();
        reader.onload = function(e){
            $('.pictures_field').append('<li id=\"picture_' + token + '\"></li>');
            $('#picture_' + token).append(img);
            $('#picture_' + token).append('<i class="fas fa-times-circle btn delete_picture" id="' + token + '"></i>');
            img.src = e.target.result;
            def.resolve(img);
        };
        reader.readAsDataURL(imageFile);
        return def.promise();
    }

    // ランダムの文字列作成
    function createToken() {
        const LENGTH = 8; // 作成文字数
        const N = 62;     //ランダム調整(BASE_STRING文字数分)
        const BASE_STRING = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        let rtnString = "";
        //文字列生成
        for(var i=0; i < LENGTH; i++) {
            rtnString += BASE_STRING.charAt( Math.floor( Math.random() * N));
        }
        return rtnString;
    }

    // 一覧

    const FAVORITE_SUBMIT_ID_FIRST = '#favorite_micropost_submit-';
    const SHARE_SUBMIT_ID_FIRST =    '#share_micropost_submit-';
    const FAVORITED_MICROPOST_SUBMIT_ID_FIRST = '#favorited_users_submit_';
    const SHARED_MICROPOST_SUBMIT_ID_FIRST =    '#shared_users_submit_';

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

    $(document).on('click', '.favorited_users_count', function() {
        $(FAVORITED_MICROPOST_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.shared_users_count', function() {
        $(SHARED_MICROPOST_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

});