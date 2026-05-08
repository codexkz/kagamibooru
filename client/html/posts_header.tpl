<div class='post-list-header'><%
    %><form class='horizontal search'><%
        %><%= ctx.makeTextInput({text: ctx.t('postsHeader.searchQuery'), id: 'search-text', name: 'search-text', value: ctx.parameters.query}) %><%
        %><wbr/><%
        %><input class='mousetrap' type='submit' value='<%= ctx.t("postsHeader.search") %>'/><%
        %><wbr/><%
        %><% if (ctx.enableSafety) { %><%
            %><input data-safety=safe type='button' class='mousetrap safety safety-safe <%- ctx.settings.listPosts.safe ? '' : 'disabled' %>'/><%
            %><input data-safety=sketchy type='button' class='mousetrap safety safety-sketchy <%- ctx.settings.listPosts.sketchy ? '' : 'disabled' %>'/><%
            %><input data-safety=unsafe type='button' class='mousetrap safety safety-unsafe <%- ctx.settings.listPosts.unsafe ? '' : 'disabled' %>'/><%
        %><% } %><%
        %><wbr/><%
        %><a class='mousetrap button append' href='<%- ctx.formatClientLink('help', 'search', 'posts') %>'><%= ctx.t('postsHeader.syntaxHelp') %></a><%
    %></form><%
    %><% if (ctx.canBulkEditTags) { %><%
        %><form class='horizontal bulk-edit bulk-edit-tags'><%
            %><span class='append hint'><%= ctx.t('postsHeader.taggingWith') %></span><%
            %><a href class='mousetrap button append open'><%= ctx.t('postsHeader.massTag') %></a><%
            %><%= ctx.makeTextInput({name: 'tag', value: ctx.parameters.tag}) %><%
            %><input class='mousetrap start' type='submit' value='<%= ctx.t("postsHeader.startTagging") %>'/><%
            %><a href class='mousetrap button append close'><%= ctx.t('postsHeader.stopTagging') %></a><%
        %></form><%
    %><% } %><%
    %><% if (ctx.enableSafety && ctx.canBulkEditSafety) { %><%
        %><form class='horizontal bulk-edit bulk-edit-safety'><%
            %><a href class='mousetrap button append open'><%= ctx.t('postsHeader.massEditSafety') %></a><%
            %><a href class='mousetrap button append close'><%= ctx.t('postsHeader.stopEditingSafety') %></a><%
        %></form><%
    %><% } %><%
    %><% if (ctx.canBulkDelete) { %><%
        %><form class='horizontal bulk-edit bulk-edit-delete'><%
            %><a href class='mousetrap button append open'><%= ctx.t('postsHeader.massDelete') %></a><%
            %><input class='mousetrap start' type='submit' value='<%= ctx.t("postsHeader.deleteSelected") %>'/><%
            %><a href class='mousetrap button append close'><%= ctx.t('postsHeader.stopDeleting') %></a><%
        %></form><%
    %><% } %><%
%></div>
