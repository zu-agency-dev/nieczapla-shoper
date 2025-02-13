{if count($related_products) && 1 == $skin_settings->productdetails->related}
    <div class="box row tab" id="box_productrelated">
        <div class="boxhead tab-head">
            <h3>
                <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                {translate key="Related products"}
            </h3>
        </div>

        <div class="innerbox tab-content product-related">
            {foreach from=$related_products item=rproduct name=list}
                {if ($rproduct->inLoyaltyExchange() && $loyalty_exchange) || !$loyalty_exchange}
                    <div data-product-id="{$rproduct->product->product_id}" data-category="{$rproduct->defaultCategory->translation->name|escape}" {if $rproduct->product->producer_id}data-producer="{$rproduct->producer->manufacturer->name|escape}"{/if} class="product product_extended row {if $smarty.foreach.list.index % 2}odd{else}even{/if}">
                        <div class="f-row">
                            <h3 class="rwd-show-medium rwd-hide-full">
                                <a href="{route function=$productRoute key=$rproduct->product->product_id productName=$rproduct->translation->name
                                                        productId=$rproduct->product->product_id}" title="{$rproduct->translation->name|escape}">
                                    <span class="productname" itemprop="isRelatedTo">{$rproduct->translation->name|escape}</span>
                                </a>
                            </h3>

                            <div>
                                <a class="details f-grid-2" href="{route function=$productRoute key=$rproduct->product->product_id productName=$rproduct->translation->name
                                                    productId=$rproduct->product->product_id}" title="{$rproduct->translation->name|escape}">
                                    <img width="{imageWidth gfx=$rproduct->getPromotingGfx() thumbnailSize=$skin_settings->img->small}" height="{imageHeight gfx=$rproduct->getPromotingGfx() thumbnailSize=$skin_settings->img->small}" src="{imageUrl width=$skin_settings->img->small height=$skin_settings->img->small type='productGfx' image=$rproduct->getPromotingGfxName() overlay=1}" alt="{$rproduct->translation->name|escape}">
                                </a>

                                <div class="f-grid-6 rwd-hide-medium">
                                    <a class="details row" href="{route function=$productRoute key=$rproduct->product->product_id productName=$rproduct->translation->name
                                                        productId=$rproduct->product->product_id}" title="{$rproduct->translation->name|escape}">
                                        <span class="productname">{$rproduct->translation->name|escape}</span>
                                    </a>
                                    <div class="js__prodcut-short-desc description resetcss row">{$rproduct->translation->short_description}</div>
                                </div>
                                
                                <div class="f-grid-4 text-right">
                                    {if $loyalty_exchange}
                                        <div class="price">
                                            <span class="label-price">{translate key="Price"}:</span>
                                            <em>{float precision=0 value=$rproduct->defaultStock->loyaltyPointsPrice(true)}</em>
                                        </div>
                                    {elseif $showprices}
                                        <div class="price">
                                            <span class="label-price">{translate key="Price"}:</span>
                                            {if $price_mode == '1' || $price_mode == '3'}
                                                {if $rproduct->specialOffer}
                                                    <p>
                                                        <em class="color">{currency value=$rproduct->defaultStock->getSpecialOfferPrice()}</em>
                                                    </p>

                                                    {if $additional_tax_info == '1'}
                                                        {assign var=productTax value=$rproduct->getTax()}
                                                        <div class="tax-additional-info">
                                                            {if ($price_mode == '1' || $price_mode == '3') && $rproduct->defaultStock->getPrice() != $rproduct->defaultStock->getPrice(true)}
                                                                {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                                            {elseif $price_mode == '2' && $rproduct->defaultStock->getPrice() != $rproduct->defaultStock->getPrice(true)}
                                                                {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                                            {else}
                                                                {translate key="excl. shipping costs"}
                                                            {/if}
                                                        </div>
                                                    {/if}

                                                    {if $rproduct->product->unit_price_calculation && $unit_price_calculation}
                                                        {assign var=unit value=$rproduct->defaultStock->getUnitPriceCalculationUnit()}
                                                        <div class="unit-price-container">
                                                            {if $price_mode == '1' || $price_mode == '3'}
                                                                <i class="default-currency">
                                                                    ( 1 {$unit->translation->name} =
                                                                    {if $rproduct->specialOffer}
                                                                        {currency value=$rproduct->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                                                    {else}
                                                                        {currency value=$rproduct->defaultStock->getUnitPriceCalculationPrice()}
                                                                    {/if}
                                                                    )
                                                                </i>
                                                            {elseif $price_mode == '2'}
                                                                <i class="default-currency">
                                                                    ( 1 {$unit->translation->name} =
                                                                    {if $rproduct->specialOffer}
                                                                        {currency value=$rproduct->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                                                    {else}
                                                                        {currency value=$rproduct->defaultStock->getUnitPriceCalculationPrice(true)}
                                                                    {/if}
                                                                    )
                                                                </i>
                                                            {/if}
                                                        </div>
                                                    {/if}

                                                    <p class="price__regular">
                                                        {translate key="Regular price"}:
                                                        <del class="price__inactive">{currency value=$rproduct->defaultStock->getPrice()}</del>
                                                    </p>

                                                    {if $showLowestPriceHistory}
                                                        <div class="f-row clear">
                                                            {translate key='The lowest price during 30 days prior to the reduction'}:
                                                            <strong class="js__omnibus-price-gross price__inactive">
                                                                {currency value=$rproduct->stock->getHistoricalLowestPrice()|escape}
                                                            </strong>
                                                            <span class="hint">
                                                                <span class="icon icon-help"></span>
                                                                <span class="hint__content">
                                                                    {translate key='If the product is sold for less than 30 days, the lowest price since the product went on sale is displayed.'}
                                                                </span>
                                                            </span>
                                                        </div>
                                                    {/if}

                                                    {if $rproduct->currency and $currency->getIdentifier() != $rproduct->currency->getIdentifier()}
                                                        <p>
                                                            {translate key="Price"} ({$rproduct->currency->currency->name|escape}):
                                                            <em  class="default-currency">({currency id=$rproduct->product->currency_id rate=1 value=$rproduct->defaultStock->getCurrencySpecialOfferPrice()})</em>
                                                        </p>
                                                    {/if}
                                                {else}
                                                    <em>{currency value=$rproduct->defaultStock->getPrice()}</em>
                                                    {if $rproduct->currency and $currency->getIdentifier() != $rproduct->currency->getIdentifier()}
                                                        <em>({currency id=$rproduct->product->currency_id rate=1 value=$rproduct->defaultStock->getCurrencyPrice()})</em>
                                                    {/if}
                                                {/if}
                                            {/if}

                                            {if $price_mode == '1' || $price_mode == '2'}
                                                {if $price_mode == '1'}
                                                    <div class="price-netto">
                                                {/if}
                                                    {if $rproduct->specialOffer}
                                                        <p>
                                                            {if $price_mode == '1'}{translate key="Net price"}:  {/if}
                                                            <em>{currency value=$rproduct->defaultStock->getSpecialOfferPrice(true)}</em>
                                                        </p>

                                                        <div class="price__additional-info">
                                                            {if $additional_tax_info == '2' && $price_mode == '2'}
                                                                {assign var=productTax value=$rproduct->getTax()}
                                                                <div class="tax-additional-info">
                                                                    {if $price_mode == '2' && $rproduct->defaultStock->getPrice() != $rproduct->defaultStock->getPrice(true)}
                                                                        {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                                                    {else}
                                                                        {translate key="excl. shipping costs"}
                                                                    {/if}
                                                                </div>
                                                            {/if}

                                                            {if $rproduct->product->unit_price_calculation && $unit_price_calculation}
                                                                {assign var=unit value=$rproduct->defaultStock->getUnitPriceCalculationUnit()}
                                                                <div class="unit-price-container">
                                                                    {if $price_mode == '2'}
                                                                        <i class="default-currency">
                                                                            ( 1 {$unit->translation->name} =
                                                                            {if $rproduct->specialOffer}
                                                                                {currency value=$rproduct->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                                                            {else}
                                                                                {currency value=$rproduct->defaultStock->getUnitPriceCalculationPrice(true)}
                                                                            {/if}
                                                                            )
                                                                        </i>
                                                                    {/if}
                                                                </div>
                                                            {/if}
                                                        </div>

                                                        {if $price_mode == '2'}
                                                            <p class="price__regular">
                                                                {translate key="Regular price"}:
                                                                <del class="price__inactive">{currency value=$rproduct->defaultStock->getPrice(true)}</del>
                                                            </p>

                                                            {if $showLowestPriceHistory}
                                                                <div class="f-row clear">
                                                                    {translate key='Lowest price'}:
                                                                    <strong class="js__omnibus-price-gross price__inactive">
                                                                        {currency value=$rproduct->stock->getHistoricalLowestPrice(true)}
                                                                    </strong>
                                                                </div>
                                                            {/if}

                                                            {if $rproduct->currency and $currency->getIdentifier() != $rproduct->currency->getIdentifier()}
                                                                <p class="product__currency">
                                                                    {translate key="Price"} ({$rproduct->currency->currency->name|escape}):
                                                                    <em class="default-currency">{currency id=$rproduct->product->currency_id rate=1 value=$rproduct->defaultStock->getCurrencySpecialOfferPrice(true)}</em>
                                                                </p>
                                                            {/if}
                                                        {/if}
                                                    {else}
                                                        <p>
                                                            {if $price_mode == '1'}
                                                                {translate key="Net price"}:
                                                            {/if}
                                                            <em>{currency value=$rproduct->defaultStock->getPrice(true)}</em>
                                                        </p>

                                                        {if $price_mode == '2'}
                                                            <div class="price__additional-info">
                                                                {if $additional_tax_info == '1'}
                                                                    {assign var=productTax value=$rproduct->getTax()}
                                                                    <div class="tax-additional-info">
                                                                        {if $price_mode == '2' && $rproduct->defaultStock->getPrice() != $rproduct->defaultStock->getPrice(true)}
                                                                            {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                                                        {else}
                                                                            {translate key="excl. shipping costs"}
                                                                        {/if}
                                                                    </div>
                                                                {/if}

                                                                {if $rproduct->product->unit_price_calculation && $unit_price_calculation}
                                                                    {assign var=unit value=$rproduct->defaultStock->getUnitPriceCalculationUnit()}
                                                                    <div class="unit-price-container">
                                                                        {if $price_mode == '2'}
                                                                            <i class="default-currency">
                                                                                ( 1 {$unit->translation->name} =
                                                                                {if $rproduct->specialOffer}
                                                                                    {currency value=$rproduct->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                                                                {else}
                                                                                    {currency value=$rproduct->defaultStock->getUnitPriceCalculationPrice(true)}
                                                                                {/if}
                                                                                )
                                                                            </i>
                                                                        {/if}
                                                                    </div>
                                                                {/if}
                                                            </div>

                                                            {if $rproduct->currency and $currency->getIdentifier() != $rproduct->currency->getIdentifier()}
                                                                <p class="product__currency">
                                                                    {translate key="Price"} ({$rproduct->currency->currency->name|escape}):
                                                                    <em class="default-currency">{currency id=$rproduct->product->currency_id rate=1 value=$rproduct->defaultStock->getCurrencyPrice(true)}</em>
                                                                </p>
                                                            {/if}
                                                        {/if}
                                                    {/if}
                                                {if $price_mode == '1'}
                                                    </div>
                                                {/if}
                                            {/if}
                                        </div>
                                    {/if}

                                    <div class="basket">
                                        <form class="{if $loyalty_exchange}loyaltyexchange{/if}" action="{route key=$basketAddRoute stockId=$rproduct->defaultStock->getIdentifier()}" method="post">
                                            {if $enablebasket && $rproduct->canBuyStock()}
                                                <fieldset>
                                                    {if !$rproduct->isBundle()}
                                                        <button class="addtobasket btn btn-red" type="submit">
                                                            <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                                                            <span>{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</span>
                                                            <input type="hidden" value="{$rproduct->defaultStock->getIdentifier()|escape}" name="stock_id">
                                                        </button>
                                                    {else}
                                                        <a class="btn btn-red" href="{route function='product' key=$rproduct->getIdentifier() productName=$rproduct->translation->name productId=$rproduct->getIdentifier()
                                        }">{translate key="check more"}</a>
                                                    {/if}
                                                </fieldset>
                                            {elseif $enable_availability_notifier && $rproduct->isEnabledNotifier()}
                                                {dynamic}
                                                    {assign var="availabilityNotifyUser" value=$rproduct->defaultStock->getAvailabilityNotifyByUser()}
                                                    <fieldset class="availability-notifier-container{if $availabilityNotifyUser != null} none{/if}">
                                                        <button class="availability-notifier-btn btn btn-red" type="submit" data-is-logged="{if true == $user_logged}true{else}false{/if}" data-stock-id="{$rproduct->defaultStock->getIdentifier()}" data-product-id="{$rproduct->product->product_id}" data-product-name="{$rproduct->translation->name|escape}">
                                                            <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                                                            <span>{translate key="Notify of product availability"}</span>
                                                        </button>
                                                    </fieldset>
                                                    {if true == $user_logged}
                                                        <fieldset class="availability-notifier-unsubscribe-container{if $availabilityNotifyUser == null} none{/if}">
                                                            <button type="submit" class="availability-notifier-unsubscribe-btn btn btn-red" data-stock-id="{$rproduct->defaultStock->stock->stock_id}">
                                                                <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                                                <span>{translate key="Cancel notify"}</span>
                                                            </button>
                                                        </fieldset>
                                                    {/if}
                                                {/dynamic}
                                            {/if}
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}
            {/foreach}
        </div>
    </div>
{/if}
