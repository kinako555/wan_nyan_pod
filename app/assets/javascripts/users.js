// 編集画面

// 編集画面タブ(プロフィール)
$(document).on('click', '.edit_profile_tb', function() {
    $('.edit_profile_tb').addClass('active');
    $('.edit_password_tb').removeClass("active");

    $('.form_edit_profile').css("display", "inline");
    $('.form_edit_password').css("display", "none");
});

// 編集画面タブ(パスワード)
$(document).on('click', '.edit_password_tb', function() {
    $('.edit_password_tb').addClass('active');
    $('.edit_profile_tb').removeClass("active");

    $('.form_edit_password').css("display", "inline");
    $('.form_edit_profile').css("display", "none");
});