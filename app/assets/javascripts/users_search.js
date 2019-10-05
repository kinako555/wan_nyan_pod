$(function(){
    let target = document.getElementById("search_word"); //検索ワード表示
    let isSearchMicroposts = false; // micropostを検索した
    
    // 検索ボタン
    $('.search_btn').on('click', function(e){
        // 空白の場合が検索処理を行わない
        if (!document.forms.search_form.search_txt.value) { 
            alert("検索ワードを入力してください")
            return false
        }
        //clickイベント後に通信が行われる
        // 投稿タブからはフラグの切り替えのみ行いう
        if (isSearchMicroposts) {
            document.forms.search_form.search_type.value = "microposts";
            isSearchMicroposts = false;
            return
        }
        document.forms.search_form.search_type.value = "users";
        $('.search_users_tb').addClass('active');
        $('.search_users_tb').removeClass('disabled');
        $('.search_microposts_tb').removeClass('active');
        $('.search_microposts_tb').removeClass('disabled');
        //検索結果
        $('.users').css('display','inline');
        $('.microposts').css('display','none');
        searchWord = document.forms.search_form.search_txt.value;
        target.innerText = '検索：' + searchWord;
    });
    // ユーザータブ
    $('.search_users_tb').on('click', function(){
        //タブ
        $('.search_users_tb').addClass('active');
        $('.search_microposts_tb').removeClass("active");
        //検索結果
        $('.users').css('display','inline');
        $('.microposts').css('display','none');
    });
    // 投稿タブ
    $('.search_microposts_tb').on('click', function(){
        //タブ
        $('.search_microposts_tb').addClass("active");
        $('.search_users_tb').removeClass("active");
        //検索結果 
        $('.microposts').css('display','inline');
        $('.users').css('display','none');
        // 再び検索ボタンをクリックするまでsearch_typeは更新されないので
        // 2回目以降のタブクリックでは行われない
        if (document.forms.search_form.search_type.value == "users"){
            isSearchMicroposts = true;
            $('.search_btn').click(); //submitイベントだとajax通信がうまくいかない
        }      
    });
});