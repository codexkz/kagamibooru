<div class='content-wrapper' id='login'>
    <h1><%= ctx.t('login.title') %></h1>
    <form>
        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({
                    text: ctx.t('login.username'),
                    name: 'name',
                    required: true,
                    pattern: ctx.userNamePattern,
                }) %>
            </li>
            <li>
                <%= ctx.makePasswordInput({
                    text: ctx.t('login.password'),
                    name: 'password',
                    required: true,
                    pattern: ctx.passwordPattern,
                }) %>
            </li>
            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('login.remember'),
                    name: 'remember-user',
                }) %>
            </li>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("login.submit") %>'/>
            <a class='append' href='<%- ctx.formatClientLink('password-reset') %>'><%= ctx.t('login.forgotPassword') %></a>
        </div>
    </form>
</div>
