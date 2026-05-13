<div class='content-wrapper' id='login' style='min-width:24em;'>
    <h1><%= ctx.t('login.title') %></h1>

    <% if (ctx.oauthEnabled) { %>
    <div class='oauth-login' style='text-align:center; margin-bottom:1.5em;'>
        <a href='/oauth/login' rel='external' style='display:inline-flex; align-items:center; gap:0.5em; padding:0.7em 2em; background:#24aadd; color:#fff; text-decoration:none; border-radius:3px; font-size:1.1em;'><% if (ctx.oauthProviderIcon) { %><img src='<%= ctx.oauthProviderIcon %>' alt='' style='width:1.2em; height:1.2em; border-radius:2px;'><% } %><%= ctx.t('login.oauthLogin').replace('{provider}', ctx.oauthProviderName) %></a>
    </div>
    <details style='margin-top:1.5em;'>
        <summary style='cursor:pointer; text-align:center; color:#888;'><%= ctx.t('login.passwordLogin') %></summary>
    <% } %>

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

    <% if (ctx.oauthEnabled) { %>
    </details>
    <% } %>
</div>
