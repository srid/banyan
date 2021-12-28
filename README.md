# banyan

WIP: Tree of time. 

Like [Wind of Change](https://windofchange.me), but using the tree model, and as a static site -- so there is no social aspect, for which you should still use WOC. I probably will begin using banyan primarily, and then cross-post its content to WOC for enabling discussions.

Fun facts:

- banyan is the first project to use Emanote [as a library](https://github.com/srid/banyan/commit/869991888349190855b3c963493f9ff352d250d0), so as to provide an Emanote-like experience without being tied to its specific domain area (Zettelkasten, notebook, wiki).

Design:

- Tree of nodes: a 'node' correponds to a post -- which may be a micro blogpost sized or tweet sized -- that is uniquely positioned in its context as identified by its location in the tree. 
- Child nodes indicate posts made *over time* (hence tree-of-time) under its parent. 
- Each node is identified by an unique ID, that appears in the URL.
- We use [Nano ID](https://github.com/ai/nanoid) in place of UUID. It is short and sufficient.
- "Next ID" is displayed in all pages, to make it easy to create new files quickly. We could improve the workflow further here.