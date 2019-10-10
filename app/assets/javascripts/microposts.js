$(function(){
    const SUBMIT_ID_FIRST = '#favorite_micropost_submit-';

    $(document).on('click', '.favorite_micropost_icon', function(){
        submitFavorite($(this).attr('value'));
    });

    $(document).on('click', '.unfavorite_micropost_icon', function(){
        submitFavorite($(this).attr('value'));
    });

    function submitFavorite(id){
        let submitID = SUBMIT_ID_FIRST + id;
        $(submitID).click();
    };
});