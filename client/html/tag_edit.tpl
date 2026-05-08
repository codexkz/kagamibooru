<div class='content-wrapper tag-edit'>
    <form>
        <ul class='input'>
            <li class='names'>
                <% if (ctx.canEditNames) { %>
                    <%= ctx.makeTextInput({
                        text: ctx.t('tagEdit.names'),
                        value: ctx.tag.names.join(' '),
                        required: true,
                    }) %>
                <% } %>
            </li>
            <li class='category'>
                <% if (ctx.canEditCategory) { %>
                    <label><%= ctx.t('tagEdit.categories') %></label>
                    <select name='categories' multiple size='<%= Math.min(Object.keys(ctx.categories).length, 6) %>'>
                        <% for (let key of Object.keys(ctx.categories)) { %>
                            <option value='<%- key %>'
                                <%= ctx.tag.categories.indexOf(key) >= 0 ? 'selected' : '' %>>
                                <%- ctx.categories[key] %>
                            </option>
                        <% } %>
                    </select>
                    <p class='hint'><%= ctx.t('tagEdit.categoriesHint') %></p>
                <% } %>
            </li>
            <li class='implications'>
                <% if (ctx.canEditImplications) { %>
                    <%= ctx.makeTextInput({text: ctx.t('tagEdit.implications')}) %>
                <% } %>
            </li>
            <li class='suggestions'>
                <% if (ctx.canEditSuggestions) { %>
                    <%= ctx.makeTextInput({text: ctx.t('tagEdit.suggestions')}) %>
                <% } %>
            </li>
            <li class='description'>
                <% if (ctx.canEditDescription) { %>
                    <%= ctx.makeTextarea({
                        text: ctx.t('tagEdit.description'),
                        value: ctx.tag.description,
                    }) %>
                <% } %>
            </li>
        </ul>

        <% if (ctx.canEditAnything) { %>
            <div class='messages'></div>

            <div class='buttons'>
                <input type='submit' class='save' value='<%= ctx.t("tagEdit.save") %>'>
            </div>
        <% } %>
    </form>
</div>
