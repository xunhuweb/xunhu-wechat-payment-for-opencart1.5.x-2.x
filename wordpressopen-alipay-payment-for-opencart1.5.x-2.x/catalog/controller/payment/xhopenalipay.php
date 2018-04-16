<?php
class Controllerpaymentxhopenalipay extends Controller {
	var $id='xhopenalipay';
	public function index() {
		$this -> load->model('checkout/order');
		$this->load->language('payment/xhopenalipay');
		
		$order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);	
		$data['button_confirm']           = $this->language->get('button_confirm');
		$data['button_loading']           = $this->language->get('button_loading');
		$data['button_back']              = $this->language->get('button_back');
		
		if ($this->request->get['route'] != 'checkout/guest_step_3') {
			$data['back'] =$this->url->link('checkout/checkout');
		} else {
			$data['back'] =$this->url->link('checkout/guest_step_2');
		}
		
		$data['payment_submit_url']            = $this->url->link('payment/xhopenalipay/send');

		if(version_compare(VERSION,'2.0.0.0', '>=')){
		    if(version_compare(VERSION,'2.2.0.0', '>=')){
		        return $this->load->view('payment/xhopenalipay', $data);
		    }
		    return $this->load->view('default/template/payment/xhopenalipay.tpl', $data);
		}else{
		    $this->data = $data;
		    $this->template = 'default/template/payment/xhopenalipay.tpl';
		     
		    $this->response->setOutput($this->render());
		}
	}

	public function send() {
	    $this->load->model('checkout/order');
	    $this->language->load('payment/xhopenalipay');
	    
	    if(!isset($this->session->data['payment_method'])
	        ||!isset($this->session->data['payment_method']['code'])
	        ||$this->session->data['payment_method']['code']!=$this->id){
	        
	        $json['error'] ='Ops!Something is wrong.';
	        $this->response->addHeader('Content-Type: application/json');
	        echo json_encode($json);
		    exit;
	    }
	   
	    $order_id                 = $this->session->data['order_id'];
	    $succeed_status = $this->config->get('xhopenalipay_order_succeed_status_id');
	    $xhopenalipay_transaction_url = rtrim($this->config->get('xhopenalipay_transaction_url'),'/');
	    $wait_status = $this->config->get('xhopenalipay_order_payWait_status_id');
	    $order_info               = $this->model_checkout_order->getOrder($order_id);
	    if(!$order_info){
	        $json['error'] ='Ops!Something is wrong.';
	        $this->response->addHeader('Content-Type: application/json');
	        echo json_encode($json);
	        exit;
	    }
	    
	    $result =$this->db->query(
	        "select order_id
	         from `" . DB_PREFIX . "order`
	         where order_status_id='$succeed_status'
	               and order_id = '$order_id'
	        limit 1;");
	    
	    if($result->num_rows){
	        $json['error']=null;
	        $this->session->data['cart'] = array();
	        $json['success'] = $this->url->link('checkout/success', '', 'SSL');
	        $this->response->addHeader('Content-Type: application/json');
	        echo json_encode($json);
		    exit;
	    }
	    $rate             = round(floatval($this->config->get('xhopenalipay_rate')),3);
		$json = array();
		$data=array(
		    'version'   => '1.1',//api version
		    'lang'       => $this->session->data['language'],
		    'is_app'    => $this->isWebApp()?'Y':'N',
		    'plugins'   => 'opencart-alipay',
		    'appid'     => $this->config->get('xhopenalipay_account'),
		    'trade_order_id'=> $order_id,
		    'payment'   => 'alipay',
		    'total_fee' =>  round($rate*floatval($this->currency->format($order_info['total'], $order_info['currency_code'], $order_info['currency_value'], FALSE)),2),
		    'title'     => $this->get_order_title($order_id),
		    'description'=> null,
		    'time'      => time(),
		    'notify_url'=> $this->url->link('payment/xhopenalipay/notify'),
		    'return_url'=> $this->url->link('checkout/success', '', 'SSL'),
		    'callback_url'=>$this->url->link('payment/wallet/failure', '', 'SSL'),
		    'nonce_str' => str_shuffle(time())
		);
		
		$hashkey          = $this->config->get('xhopenalipay_secret');
		
		$data['hash']     = $this->generate_xh_hash($data,$hashkey);
		$url              = $xhopenalipay_transaction_url.'/payment/do.html';
		
		try {
		    $response     = $this->http_post($url, json_encode($data));
		    $result       = $response?json_decode($response,true):null;
		    if(!$result){
		        throw new Exception('Internal server error',500);
		    }
		     
		    $hash         = $this->generate_xh_hash($result,$hashkey);
		    if(!isset( $result['hash'])|| $hash!=$result['hash']){
		        throw new Exception(__('Invalid sign!',XH_xhopenalipay_Payment),40029);
		    }
		
		    if($result['errcode']!=0){
		        throw new Exception($result['errmsg'],$result['errcode']);
		    }
		    
		    if(method_exists($this->model_checkout_order,'confirm')){
		        if ($order_info && $order_info['order_status_id']) {
		            $this->model_checkout_order->update($order_id, $wait_status, 'Waitting for payment.', true);
		        }else{
		            $this->model_checkout_order->confirm($order_id, $wait_status, 'Waitting for payment.', true);
		        }
		    }else{
		        $this->model_checkout_order->addOrderHistory($order_id, $wait_status, 'Waitting for payment.', true);
		    }
		    
		    $this->session->data['cart'] = array();
		    $json['success'] = $result['url'];
		    $this->response->addHeader('Content-Type: application/json');
		    echo json_encode($json);
		    exit;
		} catch (Exception $e) {
		    $json['error'] ="errcode:{$e->getCode()},errmsg:{$e->getMessage()}";
		    $this->response->addHeader('Content-Type: application/json');
		    print(json_encode($json));
		    exit;
		}
	}
	
	public  function isWebApp(){
	    if(!isset($_SERVER['HTTP_USER_AGENT'])){
	        return false;
	    }
	
	    $u=strtolower($_SERVER['HTTP_USER_AGENT']);
	    if($u==null||strlen($u)==0){
	        return false;
	    }
	
	    preg_match('/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/',$u,$res);
	
	    if($res&&count($res)>0){
	        return true;
	    }
	
	    if(strlen($u)<4){
	        return false;
	    }
	
	    preg_match('/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/',substr($u,0,4),$res);
	    if($res&&count($res)>0){
	        return true;
	    }
	
	    $ipadchar = "/(ipad|ipad2)/i";
	    preg_match($ipadchar,$u,$res);
	    return $res&&count($res)>0;
	}
	private function http_post($url,$data){
	    if(!function_exists('curl_init')){
	        throw new Exception('php未安装curl组件',500);
	    }
	    $protocol = (! empty ( $_SERVER ['HTTPS'] ) && $_SERVER ['HTTPS'] !== 'off' || $_SERVER ['SERVER_PORT'] == 443) ? "https://" : "http://";
	    $siteurl= $protocol.$_SERVER['HTTP_HOST'];
	    $ch = curl_init();
	    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
	    curl_setopt($ch,CURLOPT_URL, $url);
	    curl_setopt($ch,CURLOPT_REFERER,$siteurl);
	    curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,FALSE);
	    curl_setopt($ch,CURLOPT_SSL_VERIFYHOST,FALSE);
	    curl_setopt($ch, CURLOPT_HEADER, FALSE);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
	    curl_setopt($ch, CURLOPT_POST, TRUE);
	    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	    $response = curl_exec($ch);
	    $httpStatusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	    $error=curl_error($ch);
	    curl_close($ch);
	    if($httpStatusCode!=200){
	        throw new Exception("invalid httpstatus:{$httpStatusCode} ,response:$response,detail_error:".$error,$httpStatusCode);
	    }
	     
	    return $response;
	}
	
	public function generate_xh_hash(array $datas,$hashkey){
	    ksort($datas);
	    reset($datas);
	     
	    $pre =array();
	    foreach ($datas as $key => $data){

	        if(is_null($data)||$data===''){continue;}
	        if($key=='hash'){
	            continue;
	        }
	        $pre[$key]=$data;
	    }
	     
	    $arg  = '';
	    $qty = count($pre);
	    $index=0;
	     
	    foreach ($pre as $key=>$val){
	        $arg.="$key=$val";
	        if($index++<($qty-1)){
	            $arg.="&";
	        }
	    }
	   
	    return md5($arg.$hashkey);
	}
	
	public function notify(){
	    $this->load->model('checkout/order');
	    $this->language->load('payment/wallet');
	    
	    $data = $_POST;
	    if(!isset($data['hash'])
	        ||!isset($data['trade_order_id'])){
	            return;
	    }
	    
	    if(isset($data['plugins'])&&$data['plugins']!='opencart-alipay'){
	        return;
	    }
	    
	    $appkey =$this->config->get('xhopenalipay_secret');
	    $hash =$this->generate_xh_hash($data,$appkey);
	    if($data['hash']!=$hash){
	        return;
	    }
	
	    $order_id                 = $data['trade_order_id'];
	    $transaction_id           = $data['trade_order_id'];
	    $msg                      = "Transaction ID:\"$transaction_id\".";
	    
	    $succeed_status = $this->config->get('xhopenalipay_order_succeed_status_id');
	    $result =$this->db->query(
	        "select order_id
	         from `" . DB_PREFIX . "order`
	        where order_status_id='$succeed_status'
	        and order_id = '$order_id'
	        limit 1;");
	     
	    if(!$result->num_rows){
	        if(method_exists($this->model_checkout_order,'confirm')){
	            $order_info =  $this->model_checkout_order->getOrder($order_id);
	            if ($order_info && $order_info['order_status_id']) {
	                $this->model_checkout_order->update($order_id, $succeed_status, $msg, true);
	            }else{
	                $this->model_checkout_order->confirm($order_id, $succeed_status, $msg, true);
	            }
	        }else{
	            $this->model_checkout_order->addOrderHistory($order_id, $succeed_status, $msg, true);
	        }
	    }
	    
	    $params = array(
	        'action'=>'success',
	        'appid'=>$this->config->get('xhopenalipay_account')
	    );
	
	    $params['hash']=$this->generate_xh_hash($params, $appkey);
	    ob_clean();
	    print json_encode($params);
	    exit;
	}
	
	private function get_order_title($order_id){
	    $title="#{$order_id}";
	    $products = $this->cart->getProducts();
	    foreach($products as $product){
	        $title.="|{$product['name']}";
	        break;
	    }
	    
	    if(count($products)>1){
	        $title.="...";
	    }
	    
	    return $title;
	}
}
?>