<div id='user-delete'>
    <form>
        <ul class='input'>
            <li>
                <%= ctx.makeCheckbox({
                    name: 'confirm-deletion',
                    text: ctx.t('userDelete.confirm'),
                    required: true,
                }) %>
            </li>
        </ul>

        <div class='messages'></div>
        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("userDelete.submit") %>'/>
        </div>
    </form>
</div>
