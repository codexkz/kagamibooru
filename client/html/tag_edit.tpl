<div class='content-wrapper tag-edit'>
    <form>
        <ul class='input'>
            <li class='names'>
                <% if (ctx.canEditNames) { %>
                    <%= ctx.makeTextInput({
                        text: 'Names',
                        value: ctx.tag.names.join(' '),
                        required: true,
                    }) %>
                <% } %>
            </li>
            <li class='category'>
                <% if (ctx.canEditCategory) { %>
                    <label>Categories</label>
                    <select name='categories' multiple size='<%= Math.min(Object.keys(ctx.categories).length, 6) %>'>
                        <% for (let key of Object.keys(ctx.categories)) { %>
                            <option value='<%- key %>'
                                <%= ctx.tag.categories.indexOf(key) >= 0 ? 'selected' : '' %>>
                                <%- ctx.categories[key] %>
                            </option>
                        <% } %>
                    </select>
                    <p class='hint'>Hold Ctrl/Cmd to select multiple</p>
                <% } %>
            </li>
            <li class='implications'>
                <% if (ctx.canEditImplications) { %>
                    <%= ctx.makeTextInput({text: 'Implications'}) %>
                <% } %>
            </li>
            <li class='suggestions'>
                <% if (ctx.canEditSuggestions) { %>
                    <%= ctx.makeTextInput({text: 'Suggestions'}) %>
                <% } %>
            </li>
            <li class='description'>
                <% if (ctx.canEditDescription) { %>
                    <%= ctx.makeTextarea({
                        text: 'Description',
                        value: ctx.tag.description,
                    }) %>
                <% } %>
            </li>
        </ul>

        <% if (ctx.canEditAnything) { %>
            <div class='messages'></div>

            <div class='buttons'>
                <input type='submit' class='save' value='Save changes'>
            </div>
        <% } %>
    </form>
</div>
