<?php echo $header; ?><?php echo isset($column_left)?$column_left:''; ?>

<?php if($lower_version){
	?>
		<link href="/admin/view/css/xhopenwechat/bootstrap/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="/admin/view/css/xhopenwechat/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <style type="text/css" >
            .form-control{max-width:400px;}
        </style>
        <div id="content">
          <div class="breadcrumb">
            <?php foreach ($breadcrumbs as $breadcrumb) { ?>
            <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
            <?php } ?>
          </div>
          <?php if ($error_warning) { ?>
          <div class="warning"><?php echo $error_warning; ?></div>
          <?php } ?>
          <div class="box">
            <div class="heading">
              <h1><img src="view/image/payment.png" alt="" /> <?php echo $heading_title; ?></h1>
              <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a></div>
            </div>
            <div class="content">
              <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form"  class="form-horizontal">
               <div class="form-group">
            <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
            <div class="col-sm-10">
              <select name="xhopenwechat_status" class="form-control" style="width:148px;">
              <?php if ($xhopenwechat_status) { ?>
              <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
              <option value="0"><?php echo $text_disabled; ?></option>
              <?php } else { ?>
              <option value="1"><?php echo $text_enabled; ?></option>
              <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
              <?php } ?>
            </select>
            </div>
          </div>

        <!--  商户号 -->
          <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-merchant"><?php echo $entry_account; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_account" value="<?php echo $xhopenwechat_account; ?>" id="input-merchant" class="form-control" />
              <span class="help-block">测试账户仅支持1元内价格</span>
              <?php if ($error_account) { ?>
              <div class="text-danger"><?php echo $error_account; ?></div>
              <?php } ?>
            </div>
          </div>
           <!--  商户号 -->

    	<!-- 商户key-->
          <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-password"><?php echo $entry_secret; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_secret" value="<?php echo $xhopenwechat_secret; ?>" class="form-control" />
              <?php if ($error_secret) { ?>
              <div class="text-danger"><?php echo $error_secret; ?></div>
              <?php } ?>
            </div>
          </div>
       <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-password"><?php echo $entry_transaction_url; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_transaction_url" value="<?php echo $xhopenwechat_transaction_url; ?>" class="form-control" />
               <span class="help-block">个人支付宝/微信即时到账，支付网关：https://pay.xunhupay.com  <a href="https://mp.xunhupay.com" target="_blank">获取Appid</a> <br/>
                                                  微信支付宝代收款，需提现，支付网关：https://pay.wordpressopen.com <a href="http://mp.wordpressopen.com " target="_blank">获取Appid</a></span>
              <?php if ($error_transaction_url) { ?>
              <div class="text-danger"><?php echo $error_transaction_url; ?></div>
              <?php } ?>
            </div>
          </div>
      <!-- 商户key--> 
      
      
         <div class="form-group required">
            <label class="col-sm-2 control-label"><?php echo $entry_rate; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_rate" value="<?php echo $xhopenwechat_rate?$xhopenwechat_rate:1; ?>"  class="form-control" />
              <span>外币转换成人民币汇率，默认是1</span>
              <?php if ($error_rate) { ?>
              <div class="text-danger"><?php echo $error_rate; ?></div>
              <?php } ?>
            </div>
          </div>
          
          
 	  <!-- 支付等待、延时支付订单状态 -->
	    <div class="form-group">
	    <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_payWait_status_id; ?></label>
         <div class="col-sm-10">
          <select name="xhopenwechat_order_payWait_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_payWait_status_id||(empty($xhopenwechat_order_payWait_status_id)&&$order_status['order_status_id']=='1')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            </div>
          </div>

  			<!-- 成功订单状态 -->
           <div class="form-group">
            <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_succeed_status; ?></label>
			<div class="col-sm-10">
           <select name="xhopenwechat_order_succeed_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_succeed_status_id||(empty($xhopenwechat_order_succeed_status_id)&&$order_status['order_status_id']=='2')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
              </div>
          </div>
		  <!-- 成功订单状态 -->
		
		  <!-- 失败订单状态 -->
      <div class="form-group">
    	<label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_failed_status; ?></label>
         <div class="col-sm-10">
          <select name="xhopenwechat_order_failed_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_failed_status_id||(empty($xhopenwechat_order_failed_status_id)&&$order_status['order_status_id']=='10')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            </div>
          </div>
        
    <!-- 失败订单状态 -->

    <!-- 订单区域 -->     
        
          <div class="form-group">
            <label class="col-sm-2 control-label" for="input-geo-zone"><?php echo $entry_geo_zone; ?></label>
            <div class="col-sm-10">
              <select name="xhopenwechat_geo_zone_id" id="input-geo-zone" class="form-control">
                <option value="0"><?php echo $text_all_zones; ?></option>
                <?php foreach ($geo_zones as $geo_zone) { ?>
                <?php if ($geo_zone['geo_zone_id'] == $xhopenwechat_geo_zone_id) { ?>
                <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
                <?php } else { ?>
                <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
                <?php } ?>
                <?php } ?>
              </select>
            </div>
          </div>
          
      <!-- 订单区域 -->

     <!-- 支付模块显示顺序 -->   
          <div class="form-group">
            <label class="col-sm-2 control-label" for="input-sort-order"><?php echo $entry_sort_order; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_sort_order" value="<?php echo $xhopenwechat_sort_order?$xhopenwechat_sort_order:0; ?>" id="input-sort-order" class="form-control" />
            </div>
          </div>
     <!-- 支付模块显示顺序 -->  
              </form>
            </div>
          </div>
        </div>
	<?php
}else{
	?>
	<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="submit" form="form-worldpay" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
        <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <div class="panel panel-default" style="height:800px;">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $heading_title; ?></h3>
      </div>
      
 
      <div class="panel-body">
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-worldpay" class="form-horizontal">
        
          <div class="form-group">
            <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
            <div class="col-sm-10">
              <select name="xhopenwechat_status" class="form-control" style="width:148px;">
              <?php if ($xhopenwechat_status) { ?>
              <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
              <option value="0"><?php echo $text_disabled; ?></option>
              <?php } else { ?>
              <option value="1"><?php echo $text_enabled; ?></option>
              <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
              <?php } ?>
            </select>
            </div>
          </div>

        <!--  商户号 -->
          <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-merchant"><?php echo $entry_account; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_account" value="<?php echo $xhopenwechat_account; ?>" id="input-merchant" class="form-control" />
               <span class="help-block">测试账户仅支持1元内价格</span>
              <?php if ($error_account) { ?>
              <div class="text-danger"><?php echo $error_account; ?></div>
              <?php } ?>
            </div>
          </div>
           <!--  商户号 -->

    	<!-- 商户key-->
          <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-password"><?php echo $entry_secret; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_secret" value="<?php echo $xhopenwechat_secret; ?>" id="input-password" class="form-control" />
              <?php if ($error_secret) { ?>
              <div class="text-danger"><?php echo $error_secret; ?></div>
              <?php } ?>
            </div>
          </div>
       <div class="form-group required">
            <label class="col-sm-2 control-label" for="input-password"><?php echo $entry_transaction_url; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_transaction_url" value="<?php echo $xhopenwechat_transaction_url; ?>" class="form-control" />
               <span class="help-block">个人支付宝/微信即时到账，支付网关：https://pay.xunhupay.com  <a href="https://mp.xunhupay.com" target="_blank">获取Appid</a> <br/>
                                                  微信支付宝代收款，需提现，支付网关：https://pay.wordpressopen.com <a href="http://mp.wordpressopen.com " target="_blank">获取Appid</a></span>
              <?php if ($error_transaction_url) { ?>
              <div class="text-danger"><?php echo $error_transaction_url; ?></div>
              <?php } ?>
            </div>
          </div>
      <!-- 商户key--> 
      
      	<div class="form-group required">
            <label class="col-sm-2 control-label"><?php echo $entry_rate; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_rate" value="<?php echo $xhopenwechat_rate?$xhopenwechat_rate:1; ?>"  class="form-control" />
              <span>外币转换成人民币汇率，默认是1</span>
              <?php if ($error_rate) { ?>
              <div class="text-danger"><?php echo $error_rate; ?></div>
              <?php } ?>
            </div>
          </div>
      
       
 	  <!-- 支付等待、延时支付订单状态 -->
	    <div class="form-group">
	    <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_payWait_status_id; ?></label>
         <div class="col-sm-10">
          <select name="xhopenwechat_order_payWait_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_payWait_status_id||(empty($xhopenwechat_order_payWait_status_id)&&$order_status['order_status_id']=='1')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            </div>
          </div>

  			<!-- 成功订单状态 -->
           <div class="form-group">
            <label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_succeed_status; ?></label>
			<div class="col-sm-10">
           <select name="xhopenwechat_order_succeed_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_succeed_status_id||(empty($xhopenwechat_order_succeed_status_id)&&$order_status['order_status_id']=='2')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
              </div>
          </div>
		  <!-- 成功订单状态 -->
		
		 
		
		  <!-- 失败订单状态 -->
      <div class="form-group">
    	<label class="col-sm-2 control-label" for="input-order-status"><?php echo $entry_order_failed_status; ?></label>
         <div class="col-sm-10">
          <select name="xhopenwechat_order_failed_status_id" class="form-control">
              <?php foreach ($order_statuses as $order_status) { ?>
              <?php if ($order_status['order_status_id'] == $xhopenwechat_order_failed_status_id||(empty($xhopenwechat_order_failed_status_id)&&$order_status['order_status_id']=='10')) { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            </div>
          </div>
        
    <!-- 失败订单状态 -->

    <!-- 订单区域 -->     
        
          <div class="form-group">
            <label class="col-sm-2 control-label" for="input-geo-zone"><?php echo $entry_geo_zone; ?></label>
            <div class="col-sm-10">
              <select name="xhopenwechat_geo_zone_id" id="input-geo-zone" class="form-control">
                <option value="0"><?php echo $text_all_zones; ?></option>
                <?php foreach ($geo_zones as $geo_zone) { ?>
                <?php if ($geo_zone['geo_zone_id'] == $xhopenwechat_geo_zone_id) { ?>
                <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
                <?php } else { ?>
                <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
                <?php } ?>
                <?php } ?>
              </select>
            </div>
          </div>
          
      <!-- 订单区域 -->

     <!-- 支付模块显示顺序 -->   
          <div class="form-group">
            <label class="col-sm-2 control-label" for="input-sort-order"><?php echo $entry_sort_order; ?></label>
            <div class="col-sm-10">
              <input type="text" name="xhopenwechat_sort_order" value="<?php echo $xhopenwechat_sort_order?$xhopenwechat_sort_order:0; ?>" id="input-sort-order" class="form-control" />
            </div>
          </div>
     <!-- 支付模块显示顺序 -->   
        </form>
        
      </div>
    </div>
  </div>
</div> 
	<?php
}?>
      
<?php echo $footer; ?> 