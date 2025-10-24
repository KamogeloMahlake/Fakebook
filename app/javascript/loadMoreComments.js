const Append = {};
Append.open = false;
function ClickableCommentsLink ()
{
  $('.more-comments').click( function () {
    $(this).on('ajax:success', function(event, data, status, xhr) {
    const postId = $(this).data("post_id");
    $("#comments_" + postId).html(data);
    $("#comments-paginator-" + postId).html("<a id='more-comments' data-post_id=" + postId + "data-type='html' data-remove='true' href='/posts/'" + postId + "/comment>show morecomments</a>");
    Append.open = true;
    Append.comment = true;
    Append.link = false;
    
    });
  });
}

function DestroyComments() 
{
  $('.delete-comment').click( function () {
  Append.id = this;
  Append.post_id = $(this).data("post_id");
  Append.comment_count = $(this).data("value");
  });
}

$( document ).ready(function () {
  ClickableCommentsLink();
  DestroyComments();

  $('.comment_content').click( function () {
    Append.id = this;
    Append.post_id = $(this).data("post_id");
    if (Append.comment_count == undefined) Append.comment_count = $(this).data("value");
    if (Append.comment_count < 4) {
      Append.comment = true;
      Append.link = false;
    } else if (Append.comment_count == 4) {
      Append.comment = false;
      Append.link = true;
    } else if (Append.comment > 4) {
      Append.comment = false;
      Append.link = false;
    }
  });
});
