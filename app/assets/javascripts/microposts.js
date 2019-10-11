$(function(){
    const FAVORITE_SUBMIT_ID_FIRST = '#favorite_micropost_submit-';
    const SHARE_SUBMIT_ID_FIRST =    '#share_micropost_submit-';

    $(document).on('click', '.favorite_micropost_icon', function(){
        $(FAVORITE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.unfavorite_micropost_icon', function(){
        $(FAVORITE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.share_micropost_icon', function(){
        $(SHARE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

    $(document).on('click', '.unshare_micropost_icon', function(){
        $(SHARE_SUBMIT_ID_FIRST + $(this).attr('value')).click();
    });

});