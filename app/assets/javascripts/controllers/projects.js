jQuery(document).ready(function($) {
  //$("#inviteUserModal").modal();
  $(".invite-user-link").click(function() {
    $("#inviteUserModal").modal('show');
  });

  $(".attachment .lightbox").click(function() {
    var lightboxModal = $("#attachmentLightBoxModal");
    var img = $(this).find('img');
    if(img) {
      var imgClone = $('<img src='+img.attr('src')+' width="100%" />');
      lightboxModal.find('.lightbox-img').html(imgClone);
      lightboxModal.find('.lightbox-file-title').text($(this).attr('data-file-name'));
      lightboxModal.find('.lightbox-file-size').text($(this).attr('data-file-size'));
      if($(this).attr('data-show-modal') != '') {
        lightboxModal.modal('show');
      }
    }
  });
});
