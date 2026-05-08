<div class='content-wrapper' id='settings'>
    <form>
        <strong><%= ctx.t('settings.title') %></strong>
        <p><%= ctx.t('settings.description') %></p>
        <ul class='input'>
            <li>
                <label><%= ctx.t('settings.language') %></label>
                <select name='language'>
                    <% for (let code of Object.keys(ctx.languages)) { %>
                        <option value='<%- code %>' <%= ctx.browsingSettings.language === code ? 'selected' : '' %>>
                            <%- ctx.languages[code] %>
                        </option>
                    <% } %>
                </select>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.keyboardShortcuts') + " <a class='append icon' href='" + ctx.formatClientLink('help', 'keyboard') + "'><i class='fa fa-question-circle-o'></i></a>",
                    name: 'keyboard-shortcuts',
                    checked: ctx.browsingSettings.keyboardShortcuts,
                }) %>
            </li>

            <li>
                <%= ctx.makeNumericInput({
                    text: ctx.t('settings.postsPerPage'),
                    name: 'posts-per-page',
                    checked: ctx.browsingSettings.postCount,
                    value: ctx.browsingSettings.postsPerPage,
                    min: 10,
                    max: 100,
                }) %>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.darkTheme'),
                    name: 'dark-theme',
                    checked: ctx.browsingSettings.darkTheme,
                }) %>
                <p class='hint'><%= ctx.t('settings.darkThemeHint') %></p>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.upscaleSmallPosts'),
                    name: 'upscale-small-posts',
                    checked: ctx.browsingSettings.upscaleSmallPosts}) %>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.endlessScroll'),
                    name: 'endless-scroll',
                    checked: ctx.browsingSettings.endlessScroll,
                }) %>
                <p class='hint'><%= ctx.t('settings.endlessScrollHint') %></p>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.postFlow'),
                    name: 'post-flow',
                    checked: ctx.browsingSettings.postFlow,
                }) %>
                <p class='hint'><%= ctx.t('settings.postFlowHint') %></p>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.transparencyGrid'),
                    name: 'transparency-grid',
                    checked: ctx.browsingSettings.transparencyGrid,
                }) %>
                <p class='hint'><%= ctx.t('settings.transparencyGridHint') %></p>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.tagSuggestions'),
                    name: 'tag-suggestions',
                    checked: ctx.browsingSettings.tagSuggestions,
                }) %>
                <p class='hint'><%= ctx.t('settings.tagSuggestionsHint') %></p>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.autoplayVideos'),
                    name: 'autoplay-videos',
                    checked: ctx.browsingSettings.autoplayVideos,
                }) %>
            </li>

            <li>
                <%= ctx.makeCheckbox({
                    text: ctx.t('settings.underscoresAsSpaces'),
                    name: 'underscores-as-spaces',
                    checked: ctx.browsingSettings.tagUnderscoresAsSpaces,
                }) %>
                <p class='hint'><%= ctx.t('settings.underscoresAsSpacesHint') %></p>
            </li>

            <li>
                <label><%= ctx.t('settings.hiddenCategories') %></label>
                <input type='text' name='hidden-categories'
                       value='<%= (ctx.browsingSettings.hiddenCategories || []).join(" ") %>'
                       placeholder='e.g. nsfw gore'>
                <p class='hint'><%= ctx.t('settings.hiddenCategoriesHint') %></p>
            </li>
        </ul>

        <div class='messages'></div>
        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("settings.save") %>'/>
        </div>
    </form>
</div>
