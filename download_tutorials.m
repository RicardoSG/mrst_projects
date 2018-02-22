function build_mrst_path_tree
   d = rootdir();

   m = fullfile(d, 'modules');
   p = split_path(genpath(d));

   i =     strncmp(m, p, length(m));
   i = i | ~cellfun(@isempty, regexp(p, '\.(git|hg|svn)'));
   i = i | ~cellfun(@isempty, regexp(p, '3rdparty'));
   i = i | cellfun(@isempty, p);

   addpath(p{~i});

   % Add modules as module root directory
   mrstPath('addroot', m);
end
