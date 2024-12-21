#ifndef AVL_TREE_H
#define AVL_TREE_H



// Définition de la structure AVL
typedef struct AVLNode {
    int id;
    int capacity;
    int consumption;
    struct AVLNode *left;
    struct AVLNode *right;
    int height;
} AVLNode;

// Prototypes des fonctions AVL
int getHeight(AVLNode *node);
AVLNode *createNode(int id, int capacity, int consumption);
int getBalance(AVLNode *node);
AVLNode *rotateRight(AVLNode *y);
AVLNode *rotateLeft(AVLNode *x);
AVLNode *insertNode(AVLNode *node, int id, int capacity, int consumption);
void freeTree(AVLNode *root);

#endif // AVL_TREE_H
