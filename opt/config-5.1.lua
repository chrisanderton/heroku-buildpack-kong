rocks_trees = {
   { name = [[user]], root = home..[[/.luarocks]] },
   { name = [[system]], root = home..[[/.apt/usr/local]] }
}

external_deps_dirs = { home..[[/.apt/usr/local]], home..[[/.apt/usr]] }

variables = {
   LUA_BINDIR = [[/app/.apt/usr/bin]],
   LUA_INCDIR = [[/app/.apt/usr/local/include/luajit-2.0]],
   LUA_LIBDIR = [[/app/.apt/usr/local/lib]]
}