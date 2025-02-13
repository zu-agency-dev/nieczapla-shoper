
{dynamic}
    <div class="info-message {if $shop_off != 1}info-message_hidden{/if}">
        <strong class="info-message__text">{translate key='Shop is in view mode'}</strong>
    </div>
    <div class="center">
        <span id="turn-classic" class="btn rwd">
    		{translate key="View full version of the site"}
		</span>
    </div>
{/dynamic}

{$snippet_post_body}
<script type="text/javascript">
    {dynamic}
        {literal}
            window.Shop = window.Shop || {};
            window.Shop.basket = window.Shop.basket || {};
            window.Shop.values = window.Shop.values || {};
        {/literal}
	    {if true == $user_logged}Shop.basket.shopVisitorId = '{$user->user->userinfo->user_id|escape|base64_encode}';{/if}
	    {if $body_class|escape == 'shop_basket_done'}Shop.basket.orderDone = true;{/if}
	    Shop.basket.basketProducts = '{if 0 != $user->basket->countProducts()}{foreach from=$user->basket item=basket_product name=basket}{$basket_product->product->product->product_id|base64_encode},{/foreach}{/if}';
		Shop.basket.categoryProducts = '{foreach from=$products item=product name=prodlist}{$product->product->product_id|base64_encode},{/foreach}';
        Shop.values.currency = '{$currency->currency->name}';
        Shop.values.decimalSep = '{$number_decimal_sep}';
        Shop.values.thousandSep = '{$number_thousand_sep}';
        Shop.values.decimalPrecision = {$number_decimal_precision};
        Shop.countryCode = '{$shop_country_code}';
        Shop.pageType = '{$body_class|escape}';
        Shop.pageId = '{$body_id|escape}'.replace(/\D/g, '');
        Shop.includeFacebookSDK = '{$xfbml|escape}';
        Shop.displayCookieInfo = '{$customer_privacy.display_cookies_information|escape}'
        Shop.cookiesViewType = '{$customer_privacy.cookies_view_type|escape}';
	{/dynamic}
</script>

{include file='consents_modal.tpl'}
{include file='configs.tpl'}