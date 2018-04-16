<div class="alert alert-warning" id="warning" style="display:none;"></div>

<div class="buttons">
    <div class="pull-right">
		<a href="<?php echo str_replace('&', '&amp;', $back); ?>" class="button"><span><?php echo $button_back; ?></span></a>
		&nbsp;&nbsp;<input type="button" id="btn-xhopenwechat-confirm" class="btn btn-primary" value="<?php echo $button_confirm; ?>">
	</div>
</div>

<script type="text/javascript">
(function($){
	$('#btn-xhopenwechat-confirm').click(function(){
			$('#warning').hide();
			$.ajax({
				type: 'POST',
				url: '<?php print $payment_submit_url;?>',
				data: {},
				dataType: 'json',
				beforeSend: function() {
					$('#btn-xhopenwechat-confirm').attr('disabled', 'disabled').val('<?php echo $button_loading; ?>');
				},			
				success: function(json) {
				    if (json['info']) {
				    	$('#btn-xhopenwechat-confirm').removeAttr('disabled').val('<?php echo $button_confirm; ?>');
	                    $('#warning').show().text(json['info']);
	                    return;
					}
	
					if (json['error']) {
						$('#btn-xhopenwechat-confirm').removeAttr('disabled').val('<?php echo $button_confirm; ?>');
						$('#warning').show().text(json['error']);
						return;
					}
	
					if (json['success']) {
						 location = json['success'];
					}
				},error:function(e){
					$('#btn-xhopenwechat-confirm').removeAttr('disabled').val('<?php echo $button_confirm; ?>');
					console.warn(e.responseText);
					$('#warning').show().text('Server internal error, please try again later.');
				}	
			});
	});
})(jQuery);
</script>


