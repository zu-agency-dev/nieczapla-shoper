{include file='header.tpl'}
<body{if $body_id} id="{$body_id|escape}"{/if}{if $body_class} class="{$body_class|escape}"{/if}>
{include file='body_head.tpl'}
    <div class="main row">
        <div class="innermain container">
            <div>
                {if 0 < $boxes_left_side|@count}
                    <div class="leftcol f-grid-3">
                        {boxesLeft}
                    </div>
                {/if}

                <div class="centercol">
                    {boxesTop}

                    {if 'search' == $list_type}
                        {include file='product/searchbox.tpl'}
                    {elseif 'producer' == $list_type}
                        {if $pages->current === 1}
                            {if $producer_description}
                                <div class="categorydesc resetcss row">
                                    {$producer_description}
                                </div>
                            {/if}
                        {/if}
                    {elseif 'category' == $list_type}
                        {if $pages->current === 1}
                            {if $category_description}
                                <div class="categorydesc resetcss row">
                                    {$category_description}
                                </div>
                            {/if}
                        {/if}
                    {/if}

                    {if $loyalty_exchange}
                        {include file="product/loyalty.tpl"}
                    {/if}

                    {if $products->getTotalItemCount() > 0}
                        <div class="box" id="box_mainproducts">
                            <div class="boxhead">
                                <h1 class="category-name">
									{if $body_class|strstr:"product_new" && $category_name|escape == ''}
										{translate key="New products"}
									{elseif $body_class|strstr:"product_promo" && $category_name|escape == ''}
										{translate key="Promotions"}
									{elseif $category_name}
										{$category_name|escape}
                                    {else}
                                        {$producer_name|escape}
									{/if}
                                </h1>

                                <div class="sort-and-view">
                                    {if true == $sort_links}
                                        <div class="sortlinks">
                                            {feature name="products_order"}
                                                {if count($sort_list) > 0}
                                                    <select class="gotourl">
                                                        {foreach from=$sort_list item=sort_type}
                                                            <option value="{$sort_type.url|escape}" {if $sort_type.type == $sort}selected{/if}>{$sort_type.name|escape}</option>
                                                        {/foreach}
                                                    </select>
                                                {else} 
                                                    <div class="products-sort-container">
                                                        <span class="products-active-sort">{translate key="Sort by"}: </span>
                                                        <div class="products-sort-options">
                                                            <a href="{array __key=urlOptions sort=1}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 1}class="active-sort"{/if}>
                                                                <b>{translate key="Product name A-Z"}</b>
                                                            </a>
                                                            <a href="{array __key=urlOptions sort=2}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 2}class="active-sort"{/if}>
                                                                <b>{translate key="Product name Z-A"}</b>
                                                            </a>
                                                            <a href="{array __key=urlOptions sort=3}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 3}class="active-sort"{/if}>
                                                                <b>{translate key="Price ascending"}</b>
                                                            </a>
                                                            <a href="{array __key=urlOptions sort=4}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 4}class="active-sort"{/if}>
                                                                <b>{translate key="Price descending"}</b>
                                                            </a>
                                                            {if $body_class|strstr:"product_new" && $category_name|escape == ''}
                                                                <a href="{array __key=urlOptions sort=5}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 5}class="active-sort"{/if}>
                                                                    <b>{translate key="Newest"}</b>
                                                                </a>
                                                            {/if}
                                                        </div>
                                                    </div>
                                                {/if}
                                            {/feature}

                                            {feature name="products_order" disabled=1}
                                                <div class="products-sort-container">
                                                    <span class="products-active-sort">{translate key="Sort by"}: </span>
                                                    <div class="products-sort-options">
                                                        <a href="{array __key=urlOptions sort=1}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 1}class="active-sort"{/if}>
                                                            <b>{translate key="Product name A-Z"}</b>
                                                        </a>
                                                        <a href="{array __key=urlOptions sort=2}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 2}class="active-sort"{/if}>
                                                            <b>{translate key="Product name Z-A"}</b>
                                                        </a>
                                                        <a href="{array __key=urlOptions sort=3}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 3}class="active-sort"{/if}>
                                                            <b>{translate key="Price ascending"}</b>
                                                        </a>
                                                        <a href="{array __key=urlOptions sort=4}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 4}class="active-sort"{/if}>
                                                            <b>{translate key="Price descending"}</b>
                                                        </a>
                                                        {if $body_class|strstr:"product_new" && $category_name|escape == ''}
                                                            <a href="{array __key=urlOptions sort=5}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if}" {if $sort == 5}class="active-sort"{/if}>
                                                                <b>{translate key="Newest"}</b>
                                                            </a>
                                                        {/if}
                                                    </div>
                                                </div>
                                            {/feature}
                                        </div>
                                    {/if}

                                    {if 1 == $skin_settings->productlist->allowviewchange && (!isset($searchDisplayFormat) || $searchDisplayFormat != false)}
                                        <ul class="prodview inline text-right">
                                            <li class="photo{if 'phot' == $view} selected{/if}"><a class="fa fa-th" href="{array __key=urlOptions view=phot}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if
                                                }" title="{translate key='Picture view'
                                            }"></a></li>
                                            <li class="full{if 'full' == $view} selected{/if}"><a class="fa fa-list" href="{array __key=urlOptions view=full}{url urlOptions=$urlOptions}{if $google}?{$google|escape}{/if
                                                }" title="{translate key='Full view'
                                            }"></a></li>
                                        </ul>
                                    {/if}
                                </div>

                                <div class="row search-info">                             
                                    {if 'search' == $list_type}
                                        <b class="count">{translate key='Products found'}: {$products->getTotalItemCount()}</b>
                                    {/if}
                                </div>

                                <div class="row paginator">
                                    {if $products->getTotalItemCount() > $products->getItemCountPerPage()}
                                        <div class="floatcenterwrap">
                                            {include file='paginator.tpl'}
                                        </div>
                                    {/if}
                                </div>
                            </div>
                            
                            <div class="innerbox">
                                {include file='product/tableofproducts.tpl'}
                                {if $products->getTotalItemCount() > $products->getItemCountPerPage()}
                                    <div class="floatcenterwrap">
                                        {include file='paginator.tpl'}
                                    </div>
                                {/if}
                            </div>
                        </div>
                    {else}
                        <div class="alert-info alert">
                            <p>{translate key="No products matching your criteria have been found."}</p>
                        </div>
                    {/if}

                    {if 'category' == $list_type}
                        {if $pages->current === 1}
                            {if $category_description_bottom}
                                <div class="categorydesc resetcss row">
                                    {$category_description_bottom}
                                </div>
                            {/if}
                        {/if}
                    {/if}

                    {boxesBottom}
                </div>

                {if 0 < $boxes_right_side|@count}
                    <div class="rightcol large f-grid-3">
                        {boxesRight}
                    </div>
                {/if}
            </div>
        </div>
    </div>
{include file='footerbox.tpl'}
{include file='footer.tpl' force_include_cache='1' force_include_cache_tags='Logic_SkinFooterGroupList,Logic_SkinFooterLinkList,Logic_SkinFooterGroup,Logic_SkinFooterLink'}
{plugin module=shop template=footer}
{include file='switch.tpl'}
{$snippet_product_list}
</body>
</html>
