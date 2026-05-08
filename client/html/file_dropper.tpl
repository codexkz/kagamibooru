<div class='file-dropper-holder'>
    <input type='file' id='<%- ctx.id %>'/>
    <label class='file-dropper' for='<%- ctx.id %>' role='button'>
        <% if (ctx.allowMultiple) { %>
            <%= ctx.t('fileDropper.dropFiles') %>
        <% } else { %>
            <%= ctx.t('fileDropper.dropFile') %>
        <% } %>
        <br/>
        <%= ctx.t('fileDropper.orClick') %>
        <% if (ctx.extraText) { %>
            <br/>
            <small><%= ctx.extraText %></small>
        <% } %>
    </label>
    <% if (ctx.allowUrls) { %>
        <div class='url-holder'>
            <input type='text' name='url' placeholder='<%- ctx.urlPlaceholder %>'/>
            <% if (ctx.lock) { %>
                <button><%= ctx.t('fileDropper.confirm') %></button>
            <% } else { %>
                <button><%= ctx.t('fileDropper.addUrl') %></button>
            <% } %>
        </div>
    <% } %>
</div>
