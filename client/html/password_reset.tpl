<div class='content-wrapper' id='password-reset'>
    <h1><%= ctx.t('passwordReset.title') %></h1>
    <% if (ctx.canSendMails) { %>
        <form autocomplete='off'>
            <ul class='input'>
                <li>
                    <%= ctx.makeTextInput({
                        text: ctx.t('passwordReset.label'),
                        name: 'user-name',
                        required: true,
                    }) %>
                </li>
            </ul>

            <p><small><%= ctx.t('passwordReset.hint') %></small></p>

            <div class='messages'></div>
            <div class='buttons'>
                <input type='submit' value='<%= ctx.t("passwordReset.submit") %>'/>
            </div>
        </form>
    <% } else { %>
        <p><%= ctx.t('passwordReset.noSupport') %></p>
        <% if (ctx.contactEmail) { %>
            <p><%= ctx.t('passwordReset.contactHint').replace('{email}', '<a href="mailto:' + ctx.contactEmail + '">' + ctx.contactEmail + '</a>') %></p>
        <% } %>
    <% } %>
</div>
