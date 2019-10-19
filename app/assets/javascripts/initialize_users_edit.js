$(function() {
    let default_edit_type = $('input[name="default_edit_type"]').val();
    // 更新失敗した場合の初期表示
    switch (default_edit_type) {
        case 'profile': 
            $('.edit_profile_tb').addClass('active');
            $('.edit_password_tb').removeClass("active");
        
            $('.form_edit_profile').css("display", "inline");
            $('.form_edit_password').css("display", "none");

            $('.form_group_profile > #error_explanation').css("display", "inline");
            $('.form_group_password > #error_explanation').css("display", "none");

            break;

        case 'password':
            $('.edit_password_tb').addClass('active');
            $('.edit_profile_tb').removeClass("active");

            $('.form_edit_password').css("display", "inline");
            $('.form_edit_profile').css("display", "none");

            $('.form_group_password > #error_explanation').css("display", "inline");
            $('.form_group_profile > #error_explanation').css("display", "none");

            break;
    }
});