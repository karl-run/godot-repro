# Repro for https://github.com/godotengine/godot/issues/18068

These repro steps assume you have godot available in your $PATH under the name `godot`. If not, replace `godot` with an absolute path to your Godot 3.0.2 binary.

It also assumes your current working directory is the root of this repo.

# `-path` works and `--path` doesn't

`godot --help` states the following:

>  --path <directory>               Path to a project (<directory> must contain a 'project.godot' file).

This seems to be wrong.

1. run `godot --path pong/project.godot`

Note that the project selector menu shows. Close godot.

2. run `godot -path pong/project.godot`

Now the actual project passed in opens directly.

# --export doesn't export relative path as expected

1. run `godot -path pong/project.godot --export "HTML5" dist/`

Output:
```
exporting res://pong.tscn
ERROR: EditorExportPlatform::save_pack: Condition ' !f ' is true. returned: ERR_CANT_CREATE
   At: editor\editor_export.cpp:818
```

Assumed error: godot is unable to create the folder

2. run `mkdir dist`
3. run `godot -path pong/project.godot --export "HTML5" dist/`

Same output.

4. run `mkdir dist`
5. run `godot -path pong/project.godot --export "HTML5" dist/index.html`

Same output.

# --export doesn't export absolute path as expected

0. delete dist folder if made in previous step (`rmdir dist`)
1. run `godot -path pong/project.godot --export "HTML5" $(pwd)/dist/`

Output:
```exporting res://pong.tscn
ERROR: EditorExportPlatform::save_pack: Condition ' !f ' is true. returned: ERR_CANT_CREATE
   At: editor\editor_export.cpp:818
```

Assumed error: godot is unable to create the folder:

2. run `mkdir dist`
3. run `godot -path pong/project.godot --export "HTML5" $(pwd)/dist/`

Export seems fine.

Content of `dist`:
```bash
$ ls -al dist/
total 11508
drwxr-xr-x 1 Karl 197121        0 May  7 19:52 ./
drwxr-xr-x 1 Karl 197121        0 May  7 19:52 ../
-rw-r--r-- 1 Karl 197121   338820 May  7 19:52 .js
-rw-r--r-- 1 Karl 197121    16116 May  7 19:52 .pck
-rw-r--r-- 1 Karl 197121 11422500 May  7 19:52 .wasm
```

Assumption: `--export` requires a output name.

4. Delete dist, and recreate folder `rm -r dist && mkdir dist`
5. run `godot -path pong/project.godot --export "HTML5" $(pwd)/dist/index`

Content of `dist`

```bash
$ ls dist/
index  index.js  index.pck  index.png  index.wasm
````

Assumption: Output requires .html?

6. Delete dist, and recreate folder `rm -r dist && mkdir dist`
7. run `godot -path pong/project.godot --export "HTML5" $(pwd)/dist/index.html`

```bash
$ ls dist
index.html  index.js  index.pck  index.png  index.wasm
```

Output seems correct.

However, running this on a Linux based OS yields the following output:

```
root@ee0f98ff81a0:~/project# ls dist
index.pck
```
