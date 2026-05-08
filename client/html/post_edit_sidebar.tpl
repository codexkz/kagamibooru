<div class='edit-sidebar'>
    <form autocomplete='off'>
        <input type='submit' value='<%= ctx.t("post.save") %>' class='submit'/>

        <div class='messages'></div>

        <% if (ctx.enableSafety && ctx.canEditPostSafety) { %>
            <section class='safety'>
                <label><%= ctx.t('post.safety') %></label>
                <div class='radio-wrapper'>
                    <%= ctx.makeRadio({
                        name: 'safety',
                        class: 'safety-safe',
                        value: 'safe',
                        selectedValue: ctx.post.safety,
                        text: ctx.t('post.safe')}) %>
                    <%= ctx.makeRadio({
                        name: 'safety',
                        class: 'safety-sketchy',
                        value: 'sketchy',
                        selectedValue: ctx.post.safety,
                        text: ctx.t('post.sketchy')}) %>
                    <%= ctx.makeRadio({
                        name: 'safety',
                        value: 'unsafe',
                        selectedValue: ctx.post.safety,
                        class: 'safety-unsafe',
                        text: ctx.t('post.unsafe')}) %>
                </div>
            </section>
        <% } %>

        <% if (ctx.canEditPostRelations) { %>
            <section class='relations'>
                <%= ctx.makeTextInput({
                    text: ctx.t('post.relations'),
                    name: 'relations',
                    placeholder: ctx.t('post.relationsPlaceholder'),
                    pattern: '^[0-9 ]*$',
                    value: ctx.post.relations.map(rel => rel.id).join(' '),
                }) %>
            </section>
        <% } %>

        <% if (ctx.canEditPostFlags && ctx.post.type === 'video') { %>
            <section class='flags'>
                <label><%= ctx.t('post.miscellaneous') %></label>
                <%= ctx.makeCheckbox({
                    text: ctx.t('post.loopVideo'),
                    name: 'loop',
                    checked: ctx.post.flags.includes('loop'),
                }) %>
                <%= ctx.makeCheckbox({
                    text: ctx.t('post.sound'),
                    name: 'sound',
                    checked: ctx.post.flags.includes('sound'),
                }) %>
            </section>
        <% } %>

        <% if (ctx.canEditPostSource) { %>
            <section class='post-source'>
                <%= ctx.makeTextarea({
                    text: ctx.t('post.source'),
                    value: ctx.post.source,
                }) %>
            </section>
        <% } %>

        <% if (ctx.canEditPostTags) { %>
            <section class='tags'>
                <%= ctx.makeTextInput({}) %>
            </section>
        <% } %>

        <% if (ctx.canEditPoolPosts) { %>
            <section class='pools'>
                <%= ctx.makeTextInput({}) %>
            </section>
        <% } %>

        <% if (ctx.canEditPostNotes) { %>
            <section class='notes'>
                <a href class='add'><%= ctx.t('post.addNote') %></a>
                <%= ctx.makeTextarea({disabled: true, text: ctx.t('post.contentMarkdown'), rows: '8'}) %>
                <a href class='delete inactive'><%= ctx.t('post.deleteNote') %></a>
                <% if (ctx.hasClipboard) { %>
                    <br/>
                    <a href class='copy'><%= ctx.t('post.exportNotes') %></a>
                    <br/>
                    <a href class='paste'><%= ctx.t('post.importNotes') %></a>
                <% } %>
            </section>
        <% } %>

        <% if (ctx.canEditPostContent) { %>
            <section class='post-content'>
                <label><%= ctx.t('post.contentLabel') %></label>
                <div class='dropper-container'></div>
            </section>
        <% } %>

        <% if (ctx.canEditPostThumbnail) { %>
            <section class='post-thumbnail'>
                <label><%= ctx.t('post.thumbnail') %></label>
                <div class='dropper-container'></div>
                <a href><%= ctx.t('post.discardThumbnail') %></a>
            </section>
        <% } %>

        <% if (ctx.canFeaturePosts || ctx.canDeletePosts || ctx.canMergePosts) { %>
            <section class='management'>
                <ul>
                    <% if (ctx.canFeaturePosts) { %>
                        <li><a href class='feature'><%= ctx.t('post.featurePost') %></a></li>
                    <% } %>
                    <% if (ctx.canMergePosts) { %>
                        <li><a href class='merge'><%= ctx.t('post.mergePost') %></a></li>
                    <% } %>
                    <% if (ctx.canDeletePosts) { %>
                        <li><a href class='delete'><%= ctx.t('post.deletePost') %></a></li>
                    <% } %>
                </ul>
            </section>
        <% } %>
    </form>
</div>
