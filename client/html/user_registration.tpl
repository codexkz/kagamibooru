<div class='content-wrapper' id='user-registration'>
    <h1><%= ctx.t('register.title') %></h1>
    <form autocomplete='off'>
        <input class='anticomplete' type='text' name='fakeuser'/>
        <input class='anticomplete' type='password' name='fakepass'/>

        <ul class='input'>
            <li>
                <%= ctx.makeTextInput({
                    text: ctx.t('register.username'),
                    name: 'name',
                    placeholder: ctx.t('register.namePlaceholder'),
                    required: true,
                    pattern: ctx.userNamePattern,
                }) %>
            </li>
            <li>
                <%= ctx.makePasswordInput({
                    text: ctx.t('register.password'),
                    name: 'password',
                    placeholder: ctx.t('register.passwordPlaceholder'),
                    required: true,
                    pattern: ctx.passwordPattern,
                }) %>
            </li>
            <li>
                <%= ctx.makeEmailInput({
                    text: ctx.t('register.email'),
                    name: 'email',
                    placeholder: ctx.t('register.emailPlaceholder'),
                }) %>
                <p class='hint'>
                    <%= ctx.t('register.emailHint') %>
                </p>
            </li>
        </ul>

        <div class='messages'></div>
        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("register.submit") %>'/>
        </div>
    </form>

    <div class='info'>
        <p><%= ctx.t('register.benefits') %></p>
        <ul>
            <li><i class='fa fa-upload'></i> <%= ctx.t('register.benefitUpload') %></li>
            <li><i class='fa fa-heart'></i> <%= ctx.t('register.benefitFavorite') %></li>
            <li><i class='fa fa-commenting-o'></i> <%= ctx.t('register.benefitComment') %></li>
            <li><i class='fa fa-star-half-o'></i> <%= ctx.t('register.benefitVote') %></li>
        </ul>
        <hr/>
        <p><%= ctx.t('register.tos').replace('{link}', "<a href='" + ctx.formatClientLink('help', 'tos') + "'>" + ctx.t('register.tosLink') + "</a>") %></p>
    </div>
</div>
