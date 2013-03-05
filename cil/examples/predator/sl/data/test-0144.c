#include "../sl.h"
#include <stdlib.h>

struct list_head {
	struct list_head *next, *prev;
};

static inline void INIT_LIST_HEAD(struct list_head *list)
{
	list->next = list;
	list->prev = list;
}

struct hlist_head {
	struct hlist_node *first;
};

struct hlist_node {
	struct hlist_node *next, **pprev;
};

#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }

static inline void INIT_HLIST_NODE(struct hlist_node *h)
{
	h->next = NULL;
	h->pprev = NULL;
}

static inline int hlist_empty(const struct hlist_head *h)
{
	return !h->first;
}

static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
{
	struct hlist_node *first = h->first;
	n->next = first;
	if (first)
		first->pprev = &n->next;
	h->first = n;
	n->pprev = &h->first;
}

struct my_hlist {
    struct list_head nested;
    struct hlist_node node;
};

void add_item(struct hlist_head *hhead) {
    struct my_hlist *item = malloc(sizeof *item);
    if (!item)
        abort();

    INIT_LIST_HEAD(&item->nested);
    INIT_HLIST_NODE(&item->node);
    hlist_add_head(&item->node, hhead);
}

int main() {
    HLIST_HEAD(my_hlist_head);

    while (___sl_get_nondet_int())
        add_item(&my_hlist_head);

    ___sl_plot(NULL);

    return 0;
}
