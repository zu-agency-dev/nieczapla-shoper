{include file='header.tpl'}
<body{if $body_id} id="{$body_id|escape}" {/if}{if $body_class} class="{$body_class|escape}" {/if}>
  {include file='body_head_checkout.tpl'}
  <div class="main row">
    <div class="innermain container">
      <div class="s-row">
        {if 0 < $boxes_left_side|@count}
          <div class="leftcol large s-grid-3">
            {boxesLeft}
          </div>
        {/if}

        <div
          class="centercol {if ($boxes_left_side|@count == 0) and ($boxes_right_side|@count == 0)}s-grid-12{elseif 0 != $boxes_left_side|@count and $boxes_right_side|@count != 0}s-grid-6{else}s-grid-9{/if}">
          {boxesTop}

          <div class="box" id="box_basketaddress">
            <form action="{route key='basketStep2'}" method="post" enctype="multipart/form-data" class="js__validate"
              data-form-validator-name='basket-address'>
              <input type="hidden" name="is_cod" value="{$isCod}" id="is_cod">
              <div>
                {include file='formantispam.tpl'}

                <div class="innerbox">
                  <div class="basket-step-border">
                    <div class="f-row">
                      <div class="f-grid-6">
                        <div class="client-data">
                          <h4 class="separator">
                            <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                            {translate key='Billing and shipping address'}
                          </h4>
                          <table class="maindata">
                            <tbody>
                              {foreach from=$table1 item=tr}
                                <tr class="{$tr.name|escape} {if $tr.name == 'phone'}js__phone-table-row{/if}">
                                  <td class="label">
                                    {if $tr.type != 'link'}
                                      <label for="input_{$tr.name|escape}">
                                        {if true == $tr.obligatory}
                                          {assign var="requiredField" value=true}
                                          <em class="color">*</em>
                                        {/if}
                                        {if $tr.type != 'checkbox'}
                                          {$tr.label|escape}:
                                        {/if}
                                      </label>
                                    {/if}

                                    {if $tr.name == 'phone'}
                                      <div
                                        class="select__phone-container js__phone-country-select-container {if !$phone_validation} none{/if}"
                                        data-phone-validation="{if $phone_validation}1{else}0{/if}"
                                        data-inpost-shipping="{$isSelectedInpostShipping}">
                                        <select name="phone_country" class="select__phone js__phone-country-select"
                                          autocomplete="chrome-off">
                                          <option value="Poland"
                                            {if $phone_country == constant('Form_Shop_Address::PHONE_TYPE_POLAND')}
                                            selected="selected" {/if} data-background-source="/libraries/flags/pl_PL.png"
                                            data-pattern-strategy="nineDigits">
                                            {translate key="Poland"}
                                          </option>

                                          <option value="Other"
                                            {if $phone_country == constant('Form_Shop_Address::PHONE_TYPE_OTHER')}
                                            selected="selected" {/if}
                                            data-background-source="/libraries/flags/system-language-dark.png"
                                            data-pattern-strategy="none">
                                            {translate key="Other"}
                                          </option>
                                        </select>

                                        <div class="hint__content hint__content_right">
                                          {translate key="The selected delivery option requires a Polish telephone number."}
                                        </div>
                                      </div>
                                    {/if}
                                  </td>

                                  <td class="input">
                                    {if 'select' == $tr.type}
                                      <select class="{if $tr.error} error{/if}" name="{$tr.name|escape}"
                                        id="input_{$tr.name|escape}">
                                        {foreach from=$tr.list item=c key=k}
                                          <option value="{$k|escape}" {if $k == $tr.value} selected="selected"
                                            {/if}{if $tr.html5data
                                                                                                    }{foreach from=$tr.html5data key=html5k item=html5d} data-{$html5k}="{$html5d.$k}" {/foreach}{/if
                                                                                                    }>{$c|escape}</option>
                                        {/foreach}
                                      </select>
                                    {elseif $tr.type === 'checkbox'}
                                      <span class="checkbox-wrap">
                                        <input type="{$tr.type|escape}" name="{$tr.name|escape}" value="1"
                                          id="input_{$tr.name|escape}" {if $tr.value} checked{/if}>
                                        <label for="input_{$tr.name|escape}"></label>
                                      </span>
                                      {if $tr.type == 'checkbox'}
                                        <label for="input_{$tr.name|escape}">{$tr.label|escape}</label>
                                      {/if}
                                    {elseif $tr.type === 'link'}
                                      <div>
                                        {if $tr.type == 'link'}
                                          <a class="btn {$tr.class|escape}" href="{$tr.href|escape}">{$tr.label|escape}</a>
                                        {/if}
                                      </div>
                                    {else}
                                      <div
                                        class="shaded_inputwrap{if $tr.error} error{/if} {if $tr.name == 'phone'} js__input-container{/if}">
                                        <input type="{$tr.type|escape}" name="{$tr.name|escape}" value="{$tr.value|escape}"
                                          id="input_{$tr.name|escape}" {if $tr.readonly == true} readonly{/if}
                                          {if $tr.name == 'phone'} data-input-mask-instance="false" {/if}>
                                      </div>
                                    {/if}
                                  </td>
                                </tr>

                                {if $tr.error}
                                  <tr class="error_{$tr.name|escape}">
                                    <td />

                                    <td class="error">
                                      <ul class="input_error">
                                        {foreach from=$tr.error item=err_text}
                                          <li>{$err_text|escape}</li>
                                        {/foreach}
                                      </ul>
                                    </td>

                                    <td />
                                  </tr>
                                {/if}
                              {/foreach}
                            </tbody>
                          </table>
                        </div>

                        <div class="client-address">
                          <h4 class="separator">{translate key='Address details'}</h4>
                          <table class="address address-handler">
                            <tbody>
                              {if 'user' == $mode && $user->user && count($user->user->addresses) > 0}
                                <tr class="select_address">
                                  <td class="label">{translate key='Available addresses'}:</td>

                                  <td class="input">
                                    <select name="address" class="js__address-for-phone">
                                      <option value="0">{translate key='New address'}</option>
                                      {foreach from=$user->user->addresses item=address}
                                        <option value="{$address->getIdentifier()}"
                                          {if $address_value == $address->getIdentifier()} selected="selected" {/if}>
                                          {$address->address->address_name|escape}
                                        </option>
                                      {/foreach}
                                    </select>
                                  </td>

                                  <td>
                                    <button type="submit" name="address_submit" value="address_submit"
                                      class="button address_submit">
                                      <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                      <span>&raquo;</span>
                                    </button>
                                  </td>
                                </tr>
                              {/if}

                              <tr class="address_type">
                                <td class="label"></td>

                                <td class="input">
                                  <span class="radio-wrap">
                                    <input type="radio" name="address_type" value="1" id="address_type1"
                                      {if 1 == (int) $address_type} checked="checked" {/if}>
                                    <label for="address_type1"></label>
                                  </span>
                                  <label for="address_type1">{translate key='private person'}</label>

                                  <span class="radio-wrap">
                                    <input type="radio" name="address_type" value="2" id="address_type2"
                                      {if 2 == (int) $address_type} checked="checked" {/if}>
                                    <label for="address_type2"></label>
                                  </span>
                                  <label for="address_type2">{translate key='company'}</label>
                                </td>

                                <td></td>
                              </tr>

                              {foreach from=$table2 item=tr}
                                <tr class="{$tr.name|escape}{if $tr.name == 'vat_eu'} additional-fields{/if}">
                                  <td class="label">
                                    <label for="input_{$tr.name|escape}">
                                      {if true == $tr.obligatory}
                                        <em class="color">*</em>
                                      {/if}
                                      {if $tr.type != 'checkbox'}
                                        {$tr.label|escape}:
                                      {/if}
                                    </label>
                                  </td>

                                  <td class="input {if $tr.type=='checkbox'}input_checkbox pb-1 pt-1 {/if}">
                                    {if 'select' == $tr.type}
                                      <select
                                        class="{if $tr.error} error{/if} {if $tr.name == 'country'} js__country-for-phone{/if}"
                                        name="{$tr.name|escape}" id="input_{$tr.name|escape}">
                                        {foreach from=$tr.list item=c key=k}
                                          <option value="{$k|escape}" {if $k == $tr.value} selected="selected"
                                            {/if}{if $tr.html5data
                                                                                                        }{foreach from=$tr.html5data key=html5k item=html5d} data-{$html5k}="{$html5d.$k}" {/foreach}{/if
                                                                                                        }>{$c|escape}
                                          </option>
                                        {/foreach}
                                      </select>
                                    {elseif $tr.type === 'checkbox'}
                                      {if $tr.name !='vat_eu' || ($tr.name =='vat_eu' && $isEnabledVatEU)}
                                        <span class="checkbox-wrap">
                                          <input type="{$tr.type|escape}" name="{$tr.name|escape}" value="1"
                                            id="input_{$tr.name|escape}" {if $tr.value} checked{/if}>
                                          <label for="input_{$tr.name|escape}"></label>
                                        </span>
                                        <label for="input_{$tr.name|escape}">{$tr.label|escape}</label>
                                        <div class="hint">
                                          <span class="icon icon-help"></span>
                                          <div class="hint__content hint__content_right">
                                            <p>
                                              {translate key='By selecting this option, I accept the obligation to settle the purchase in my country and declare that I am authorized to make transactions with 0% VAT rate as part of intra-EU supply of goods, which means'}:
                                            </p>
                                            <p class="mt-2">
                                              -{translate key='I represent a company from a different European Union country than the seller'},
                                            </p>
                                            <p>
                                              -{translate key='I have a valid VAT EU identification number in the VIES system, registered for intra-EU transactions, containing two-letter country code'},
                                            </p>
                                            <p>
                                              -{translate key='the shipping address is the official address of the company'}.
                                            </p>
                                            <a href="https://ec.europa.eu/taxation_customs/vies/" target="_blank"
                                              rel="noopener">
                                              {translate key="Check if the company is in the VIES system"}
                                            </a>
                                          </div>
                                        </div>
                                      {/if}
                                    {else}
                                      <div class="shaded_inputwrap{if $tr.error} error{/if}">
                                        <input {if $tr.name == 'zip'}data-mask="__-___"
                                            data-pattern="{literal}^(\d{2})(-)(\d{3})${/literal}" data-valid-pattern="00-000"
                                            {/if} type="{if $tr.name == 'zip'}tel{else}{$tr.type|escape}{/if}"
                                            name="{$tr.name|escape}" value="{$tr.value|escape}" id="input_{$tr.name|escape}">
                                        </div>
                                      {/if}
                                    </td>
                                  </tr>

                                  {if $tr.error}
                                    <tr class="error_{$tr.name|escape}">
                                      <td />

                                      <td class="error">
                                        <ul class="input_error">
                                          {foreach from=$tr.error item=err_text}
                                            <li>{$err_text|escape}</li>
                                          {/foreach}
                                        </ul>
                                      </td>

                                      <td />
                                    </tr>
                                  {/if}
                                {/foreach}

                                <tr class="different_address">
                                  <td class="label"></td>
                                  <td class="input">
                                    <span class="checkbox-wrap">
                                      <input type="checkbox" name="different" value="1" id="address_different"
                                        {if 1 == (int) $different_value} checked="checked" {/if}>
                                      <label for="address_different"></label>
                                    </span>
                                    <label for="address_different">{translate key='Different shipping address'}</label>
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        </div>

                        {plugin module=shop template=basket-address}

                        <div class="client-add-info f-grid-6">
                          <div class="client-address-different address-handler" data-diff-address="1">
                            <h4 class="different separator">{translate key='Different shipping address'}</h4>
                            <table class="address-different">
                              <tbody>
                                {if 'user' == $mode && $user->user && count($user->user->addresses) > 0}
                                  <tr class="different select_address2">
                                    <td class="label">{translate key='Available addresses'}:</td>

                                    <td class="input">
                                      <select name="address2" class="js__address-for-phone2">
                                        <option value="0">{translate key='New address'}</option>
                                        {foreach from=$user->user->addresses item=address}
                                          <option value="{$address->getIdentifier()}"
                                            {if $address2_value == $address->getIdentifier()} selected="selected" {/if}>
                                            {$address->address->address_name|escape}
                                          </option>
                                        {/foreach}
                                      </select>
                                    </td>

                                    <td>
                                      <button type="submit" name="address_submit2" value="address_submit2"
                                        class="button address_submit">
                                        <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                        <span>&raquo;</span>
                                      </button>
                                    </td>
                                  </tr>
                                {/if}

                                {foreach from=$table3 item=tr}
                                  <tr class="different {$tr.name|escape} {if $tr.name == 'phone2'}js__phone-table-row{/if}">
                                    <td class="label">
                                      <label for="input_{$tr.name|escape}">
                                        {if true == $tr.obligatory}
                                          <em class="color">*</em>
                                        {/if}
                                        {$tr.label|escape}:
                                      </label>

                                      {if $tr.name == 'phone2'}
                                        <div
                                          class="select__phone-container js__phone-country-select-container {if !$phone_validation} none{/if}"
                                          data-phone-validation="{if $phone_validation}1{else}0{/if}"
                                          data-inpost-shipping="{$isSelectedInpostShipping}">
                                          <select name="phone_country2" class="select__phone js__phone-country-select"
                                            autocomplete="chrome-off">
                                            <option value="Poland"
                                              {if $phone_country2 == constant('Form_Shop_Address::PHONE_TYPE_POLAND')}
                                              selected="selected" {/if} data-background-source="/libraries/flags/pl_PL.png"
                                              data-pattern-strategy="nineDigits">
                                              {translate key="Poland"}
                                            </option>

                                            <option value="Other"
                                              {if $phone_country2 == constant('Form_Shop_Address::PHONE_TYPE_OTHER')}
                                              selected="selected" {/if}
                                              data-background-source="/libraries/flags/system-language-dark.png"
                                              data-pattern-strategy="none">
                                              {translate key="Other"}
                                            </option>
                                          </select>

                                          <div class="hint__content hint__content_right">
                                            {translate key="The selected delivery option requires a Polish telephone number."}
                                          </div>
                                        </div>
                                      {/if}
                                    </td>

                                    <td class="input">
                                      {if 'select' == $tr.type}
                                        <select
                                          class="{if $tr.error} error{/if} {if $tr.name == 'country2'} js__country-for-phone2{/if}"
                                          name="{$tr.name|escape}" id="input_{$tr.name|escape}">
                                          {foreach from=$tr.list item=c key=k}
                                            <option value="{$k|escape}" {if $k == $tr.value} selected="selected"
                                              {/if}{if $tr.html5data
                                                                                                                }{foreach from=$tr.html5data key=html5k item=html5d} data-{$html5k}="{$html5d.$k}" {/foreach}{/if
                                                                                                                }>{$c|escape}
                                            </option>
                                          {/foreach}
                                        </select>
                                      {else}
                                        <div
                                          class="shaded_inputwrap{if $tr.error} error{/if} {if $tr.name == 'phone2'} js__input-container{/if}">
                                          <input {if $tr.name == 'zip2'} data-mask="__-___"
                                              data-pattern="{literal}^(\d{2})(-)(\d{3})${/literal}" data-valid-pattern="00-000"
                                              {/if} {if $tr.name == 'phone2'} data-input-mask-instance="false" {/if}
                                              type="{if $tr.name == 'zip2'}tel{else}{$tr.type|escape}{/if}"
                                              name="{$tr.name|escape}" value="{$tr.value|escape}" id="input_{$tr.name|escape}">
                                          </div>
                                        {/if}
                                      </td>
                                    </tr>

                                    {if $tr.error}
                                      <tr class="different error_{$tr.name|escape}">
                                        <td />

                                        <td class="error">
                                          <ul class="input_error">
                                            {foreach from=$tr.error item=err_text}
                                              <li>{$err_text|escape}</li>
                                            {/foreach}
                                          </ul>
                                        </td>

                                        <td />
                                      </tr>
                                    {/if}
                                  {/foreach}
                                </tbody>
                              </table>
                            </div>

                            <h4 class="separator">{translate key='Additional information'}</h4>
                            <table>
                              <tbody>
                                <tr>
                                  <td class="label">
                                    <label for="comment">{translate key='Notes'}</label>
                                  </td>
                                  <td class="input" colspan="2">
                                    <div class="shaded_textareawrap">
                                      <textarea name="comment" rows="5" cols="30">{$comment_value|escape}</textarea>
                                    </div>
                                  </td>
                                </tr>

                                {if $comment_error}
                                  <tr>
                                    <td />

                                    <td class="error">
                                      <ul class="input_error">
                                        {foreach from=$comment_error item=err_text}
                                          <li>{$err_text|escape}</li>
                                        {/foreach}
                                      </ul>
                                    </td>

                                    <td />
                                  </tr>
                                {/if}

                                {plugin module=shop template=basket-payment-regulations}

                                {foreach from=$additional_fields item=field}
                                  {assign var=name value='additional_'|cat:$field->getIdentifier()}

                                  {if $additional_error.$name}
                                    {if $field->field->type == constant('Logic_AdditionalField::TYPE_CHECKBOX')}
                                      <tr class="witherror witherror_checkbox">
                                      {else}
                                      <tr class="witherror witherror_text">
                                      {/if}
                                    {else}
                                    <tr class="additional-fields">
                                    {/if}

                                    {if $field->field->type == constant('Logic_AdditionalField::TYPE_HIDDEN')}
                                      <td class="input_hidden" colspan="3">
                                        {additionalField field=$field name=$name value=$additional_value.$name|escape}
                                      </td>
                                    {elseif $field->field->type == constant('Logic_AdditionalField::TYPE_INFO')}
                                      <td></td>
                                      <td class="input_info" colspan="2">
                                        <p>{$field->translation->description}</p>
                                      </td>
                                    {else}
                                      <td
                                        class="label{if $field->field->type == constant('Logic_AdditionalField::TYPE_CHECKBOX')} label_checkbox{/if}">
                                        {if $field->field->type == constant('Logic_AdditionalField::TYPE_CHECKBOX')}
                                          {if 1 == $field->field->req}<em class="color">*</em>{/if}
                                        {else}
                                          <label for="{$name|escape}">
                                            {if 1 == $field->field->req}<em class="color">*</em>{/if}
                                            {$field->translation->description}
                                          </label>
                                        {/if}
                                      </td>
                                      <td
                                        class="input{if $field->field->type == constant('Logic_AdditionalField::TYPE_CHECKBOX')} input_checkbox{/if}"
                                        colspan="2">
                                        {if $field->field->type == constant('Logic_AdditionalField::TYPE_CHECKBOX')}
                                          <span class="checkbox-wrap">
                                            {additionalField field=$field name=$name value=$additional_value.$name editable=true}
                                            <label for="{$name|escape}"></label>
                                          </span>
                                          <label for="{$name|escape}">{$field->translation->description}</label>
                                        {elseif $field->field->type == constant('Logic_AdditionalField::TYPE_TEXT')}
                                          <div class="shaded_inputwrap{if $additional_error.$name} error{/if}">
                                            {additionalField field=$field name=$name value=$additional_value.$name|escape editable=true}
                                          </div>
                                        {else}
                                          {additionalField field=$field name=$name value=$additional_value.$name|escape editable=true}
                                        {/if}
                                      </td>
                                    {/if}
                                  </tr>

                                  {if $additional_error.$name}
                                    <tr class="errorline">
                                      <td />

                                      <td class="error">
                                        {formErrors errors=$additional_error.$name class="input_error"}
                                      </td>

                                      <td />
                                    </tr>
                                  {/if}
                                {/foreach}

                                {foreach from=$table4 item=tr}
                                  <tr class="{$tr.name|escape}">
                                    <td class="label">
                                      <label for="input_{$tr.name|escape}">
                                        {if true == $tr.obligatory}
                                          <em class="color">*</em>
                                        {/if}
                                        {if $tr.type != 'checkbox'}
                                          {$tr.label|escape}:
                                        {/if}
                                      </label>
                                    </td>

                                    <td class="input">
                                      {if 'select' == $tr.type}
                                        <select class="{if $tr.error} error{/if}" name="{$tr.name|escape}"
                                          id="input_{$tr.name|escape}">
                                          {foreach from=$tr.list item=c key=k}
                                            <option value="{$k|escape}" {if $k == $tr.value} selected="selected"
                                              {/if}{if $tr.html5data
                                                                                                        }{foreach from=$tr.html5data key=html5k item=html5d} data-{$html5k}="{$html5d.$k}" {/foreach}{/if
                                                                                                        }>{$c|escape}</option>
                                          {/foreach}
                                        </select>
                                      {elseif $tr.type === 'checkbox'}
                                        <span class="checkbox-wrap">
                                          <input type="{$tr.type|escape}" name="{$tr.name|escape}" value="1"
                                            id="input_{$tr.name|escape}" {if $tr.value} checked{/if}>
                                          <label for="input_{$tr.name|escape}"></label>
                                        </span>
                                        {if $tr.type == 'checkbox'}
                                          <label for="input_{$tr.name|escape}">{$tr.label|escape}</label>
                                        {/if}

                                        {if $tr.legal_notes}
                                          <p>
                                            {$tr.legal_notes}
                                          </p>
                                        {/if}
                                      {else}
                                        <div class="shaded_inputwrap{if $tr.error} error{/if}">
                                          <input type="{$tr.type|escape}" name="{$tr.name|escape}" value="{$tr.value|escape}"
                                            id="input_{$tr.name|escape}">
                                        </div>
                                      {/if}
                                    </td>
                                  </tr>

                                  {if $tr.error}
                                    <tr class="error_{$tr.name|escape}">
                                      <td />

                                      <td class="error">
                                        <ul class="input_error">
                                          {foreach from=$tr.error item=err_text}
                                            <li>{$err_text|escape}</li>
                                          {/foreach}
                                        </ul>
                                      </td>

                                      <td />
                                    </tr>
                                  {/if}
                                {/foreach}
                              </tbody>
                            </table>
                          </div>
                        </div>

                        {if $requiredField}
                          <div>
                            <span><em class="color">*</em> - {translate key="Field mandatory"}</span>
                          </div>
                        {/if}
                      </div>

                      {if $shipping_data}
                        <input type="hidden" name="shipping_data" value="{$shipping_data|escape}">
                      {/if}
                      <input type="hidden" name="addressform" value="{$mode|escape}">

                      <div class="bottombuttons">
                        <button type="submit" name="button2" value="button2" class="important summary btn-red btn">
                          <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                          <span>
                            {if $shipping_extra_step}
                              {translate key='Payment & Shipping'}
                            {else}
                              {translate key='Summary'}
                            {/if}
                          </span>
                        </button>

                        {$recaptcha}

                        <button type="submit" name="button1" value="button1" class="btn back js__no-validate">
                          <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                          <span>{translate key='Back'}</span>
                        </button>
                      </div>
                    </div>
                  </div>
                </form>
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

      <script type="text/javascript">
        try {literal}{{/literal} 
        {literal}
          window.Shop = window.Shop || {};
          window.Shop.values = window.Shop.values || {};
        {/literal}
        Shop.values.Country2Shipping = {$country2shipping}; 
        Shop.values.ShippingExtraStep = {$shipping_extra_step}; 
        Shop.values.reverseTable = {$reverse_address_order}; 
        {feature name="vat_eu"}
        {if $isEnabledVatEU}Shop.values.countryCode={$shopCountry}; Shop.values.euCountries = [
          {foreach from=$countriesVatEU item=country}{$country},
          {/foreach}];
        {/if}
        {/feature} 
        {literal}}{/literal} catch(e) {literal}{ }{/literal}
      </script>
      {include file='footerbox.tpl'}
      {include file='footer.tpl' force_include_cache='1' force_include_cache_tags='Logic_SkinFooterGroupList,Logic_SkinFooterLinkList,Logic_SkinFooterGroup,Logic_SkinFooterLink'}
      {plugin module=shop template=footer}
      {include file='switch.tpl'}
      </body>

    </html>