void
shift(unsigned int *tag, int i)
{
	if (i > 0) /* left circular shift */
		*tag = ((*tag << i) | (*tag >> (LENGTH(tags) - i)));
	else       /* right circular shift */
		*tag = (*tag >> (- i) | *tag << (LENGTH(tags) + i));
}

/* send a window to the next/prev tag */
void
shifttag(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };

	if (!selmon->clients)
		return;

	shift(&shifted.ui, arg->i);
	tag(&shifted);
}

/* send a window to the next/prev tag that has a client, else it moves it to
 * the next/prev one. */
void
shifttagclients(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };
	Client *c;
	unsigned int tagmask = 0;

	for (c = selmon->clients; c; c = c->next)
		tagmask = tagmask | c->tags;

	do
		shift(&shifted.ui, arg->i);
	while (tagmask && !(shifted.ui & tagmask));

	tag(&shifted);
}

/* view the next/prev tag */
void
shiftview(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };

	shift(&shifted.ui, arg->i);
	view(&shifted);
}

/* view the next/prev tag that has a client, else view the next/prev tag */
void
shiftviewclients(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };
	Client *c;
	unsigned int tagmask = 0;

	for (c = selmon->clients; c; c = c->next)
		tagmask = tagmask | c->tags;

	do
		shift(&shifted.ui, arg->i);
	while (tagmask && !(shifted.ui & tagmask));

	view(&shifted);
}

/* move the active window to the next/prev tag and view it's new tag */
void
shiftboth(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };

	shift(&shifted.ui, arg->i);
	tag(&shifted);
	view(&shifted);
}

/* swaptags: https://dwm.suckless.org/patches/swaptags, used below */
void
swaptags(const Arg *arg)
{
	Client *c;
	unsigned int newtag = arg->ui & TAGMASK;
	unsigned int curtag = selmon->tagset[selmon->seltags];

	if (newtag == curtag || !curtag || (curtag & (curtag-1)))
		return;

	for (c = selmon->clients; c != NULL; c = c->next) {
		if ((c->tags & newtag) || (c->tags & curtag))
			c->tags ^= curtag ^ newtag;
		if (!c->tags)
			c->tags = newtag;
	}

	//uncomment to 'view' the new swaped tag
	//selmon->tagset[selmon->seltags] = newtag;

	focus(NULL);
	arrange(selmon);
}

/* swaps "tags" (all the clients on it) with the next/prev tag */
void
shiftswaptags(const Arg *arg)
{
	Arg shifted = { .ui = selmon->tagset[selmon->seltags] };

	shift(&shifted.ui, arg->i);
	swaptags(&shifted);
}
