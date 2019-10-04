$(function(){
    let searchWord; //検索ワード
    let target = document.getElementById("search_word"); //検索ワード表示
    let isSearchMicroposts = false; // micropostを検索した
    //formData作成
    function createFormData(searchType) {
        let formData = new FormData();
        formData.append('search_type', searchType);
        formData.append('search_word', searchWord);
        return formData;
    };
    //ajax送信
    function sending(formData) {
        // CSRF対策（独自のajax処理を行う場合、head内にあるcsrf-tokenを取得して送る必要がある）
        $.ajaxPrefilter(function(options, originalOptions, jqXHR){
            let token;
            if (!options.crossDomain){
                token = $('meta[name="csrf-token"]').attr('content');
                if (token) return jqXHR.setRequestHeader('X-CSRF-Token', token);
            };
        });
        $.ajax({
            url:         '/search',
            datatype:    'json',
            type:        'post',
            data:        formData,
            processData: false,
            contentType: false
          })
          .then(
              data => alert("成功"),
              error => alert("失敗")
          );
    };
    // 検索ボタン
    $('.search_btn').on('click', function(){
        // 空文字チェック
        if (!document.forms.search_form.search_txt.value) { 
            alert("検索ワードを入力してください")
            return
        }
        //タブ
        $('.search_users_tb').addClass('active');
        $('.search_users_tb').removeClass('disabled');
        $('.search_microposts_tb').removeClass('active');
        $('.search_microposts_tb').removeClass('disabled');
        //検索結果
        $('.users').css('display','inline');
        $('.microposts').css('display','none');
        searchWord = document.forms.search_form.search_txt.value;
        target.innerText = '検索：' + searchWord;      
        let formData = createFormData("users");
        sending(formData);
        isSearchMicroposts = false; // フラグ初期化
    });
    // ユーザータブ
    $('.search_users_tb').on('click', function(){
        //タブ
        $('.search_users_tb').addClass('active');
        $('.search_microposts_tb').removeClass("active");
        //検索結果
        $('.users').css('display','inline');
        $('.microposts').css('display','none');
        // ユーザー表示
        //その他２つ非表示
    });
    // 投稿タブ
    $('.search_microposts_tb').on('click', function(){
        //タブ
        $('.search_microposts_tb').addClass("active");
        $('.search_users_tb').removeClass("active");
        //検索結果 
        $('.microposts').css('display','inline');
        $('.users').css('display','none');
        if (!isSearchMicroposts) {
            let formData = createFormData("microposts");
            sending(formData);
            isSearchMicroposts = true;
        }  
    });
});