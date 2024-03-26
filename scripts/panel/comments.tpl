{include file='header.tpl'}
<body{if $body_id} id="{$body_id|escape}"{/if}{if $body_class} class="{$body_class|escape}"{/if}>
    {include file='body_head.tpl'}
    <div class="main row">
        <div class="innermain container">
            <div class="s-row">
                {if 0 < $boxes_left_side|@count}
                    <div class="leftcol large s-grid-3">
                        {boxesLeft}
                    </div>
                {/if}

                <div class="centercol {if ($boxes_left_side|@count == 0) and ($boxes_right_side|@count == 0)}s-grid-12{elseif 0 != $boxes_left_side|@count and $boxes_right_side|@count != 0}s-grid-6{else}s-grid-9{/if}">
                    {boxesTop}

                    {if $articles && count($articles) > 0}
                        {include file='news/listofarticles.tpl'}
                    {/if}

                    <div class="box" id="box_productcomments">
                        <div class="boxhead">
                            <span>
                                <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                {translate key="Products reviews"}
                            </span>
                        </div>

                        <div class="innerbox">
                            {foreach from=$user->user->comments item=comment name=list}
                                <div class="productcomment row">
                                    <h5><a class="product" href="{route function='product' key=$comment->product->getIdentifier() productName=$comment->product->translation->name
                                        productId=$comment->product->getIdentifier()}" title="{$comment->translation->name|escape}">{
                                        $comment->product->translation->name|escape}</a></h5>
                                    <div class="date">{date value=$comment->comment->date}</div>
                                    <p>{$comment->comment->content|escape}</p>
                                </div>
                            {/foreach}
                        </div>
                    </div>

                    {boxesBottom}
                </div>

                {if 0 < $boxes_right_side|@count}
                    <div class="rightcol large s-grid-3">
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
</body>
</html>
