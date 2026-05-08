<div id='user-edit'>
    <form>
        <input class='anticomplete' type='text' name='fakeuser'/>
        <input class='anticomplete' type='password' name='fakepass'/>

        <ul class='input'>
            <% if (ctx.canEditName) { %>
                <li>
                    <%= ctx.makeTextInput({
                        text: ctx.t('userEdit.userName'),
                        name: 'name',
                        value: ctx.user.name,
                        pattern: ctx.userNamePattern,
                    }) %>
                </li>
            <% } %>

            <% if (ctx.canEditPassword) { %>
                <li>
                    <%= ctx.makePasswordInput({
                        text: ctx.t('userEdit.password'),
                        name: 'password',
                        placeholder: ctx.t('userEdit.passwordPlaceholder'),
                        pattern: ctx.passwordPattern,
                    }) %>
                </li>
            <% } %>

            <% if (ctx.canEditEmail) { %>
                <li>
                    <%= ctx.makeEmailInput({
                        text: ctx.t('userEdit.email'),
                        name: 'email',
                        value: ctx.user.email,
                    }) %>
                </li>
            <% } %>

            <% if (ctx.canEditRank) { %>
                <li>
                    <%= ctx.makeSelect({
                        text: ctx.t('userEdit.rank'),
                        name: 'rank',
                        keyValues: ctx.ranks,
                        selectedKey: ctx.user.rank,
                    }) %>
                </li>
            <% } %>

            <% if (ctx.canEditAvatar) { %>
                <li class='avatar'>
                    <label><%= ctx.t('userEdit.avatar') %></label>
                    <div id='avatar-content'></div>
                    <div id='avatar-radio'>
                        <%= ctx.makeRadio({
                            text: ctx.t('userEdit.gravatar'),
                            name: 'avatar-style',
                            value: 'gravatar',
                            selectedValue: ctx.user.avatarStyle,
                        }) %>

                        <%= ctx.makeRadio({
                            text: ctx.t('userEdit.manualAvatar'),
                            name: 'avatar-style',
                            value: 'manual',
                            selectedValue: ctx.user.avatarStyle,
                        }) %>
                    </div>
                </li>
            <% } %>
        </ul>

        <div class='messages'></div>

        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("userEdit.save") %>'/>
        </div>
    </form>
</div>
