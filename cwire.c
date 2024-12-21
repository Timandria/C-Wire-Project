#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure AVL pour les stations typedef struct AVLNode {
    int id;
    int capacity;
    int consumption;
    struct AVLNode *left;
    struct AVLNode *right;
    int height;
} AVLNode;

// Fonction pour calculer la hauteur d'un nœud int getHeight(AVLNode *node) {
    return node ? node->height : 0;
}

// Fonction pour calculer le facteur d'équilibrage int getBalance(AVLNode *node) {
    return node ? getHeight(node->left) - getHeight(node->right) : 0;
}

// Créer un nouveau nœud AVL AVLNode *createNode(int id, int capacity, int consumption) {
    AVLNode *node = (AVLNode *)malloc(sizeof(AVLNode));
    node->id = id;
    node->capacity = capacity;
    node->consumption = consumption;
    node->left = node->right = NULL;
    node->height = 1;
    return node;
}

// Rotation à droite AVLNode *rotateRight(AVLNode *y) {
    AVLNode *x = y->left;
    AVLNode *T = x->right;
    x->right = y;
    y->left = T;
    y->height = 1 + fmax(getHeight(y->left), getHeight(y->right));
    x->height = 1 + fmax(getHeight(x->left), getHeight(x->right));
    return x;
}

// Rotation à gauche AVLNode *rotateLeft(AVLNode *x) {
    AVLNode *y = x->right;
    AVLNode *T = y->left;
    y->left = x;
    x->right = T;
    x->height = 1 + fmax(getHeight(x->left), getHeight(x->right));
    y->height = 1 + fmax(getHeight(y->left), getHeight(y->right));
    return y;
}

// Insérer un nœud dans l'arbre AVL AVLNode *insertNode(AVLNode *node, int id, int capacity, int consumption) {
    if (!node) return createNode(id, capacity, consumption);
    if (id < node->id)
        node->left = insertNode(node->left, id, capacity, consumption);
    else if (id > node->id)
        node->right = insertNode(node->right, id, capacity, consumption);
    else {
        node->consumption += consumption;
        return node;
    }
    node->height = 1 + fmax(getHeight(node->left), getHeight(node->right));
    int balance = getBalance(node);
    if (balance > 1 && id < node->left->id) return rotateRight(node);
    if (balance < -1 && id > node->right->id) return rotateLeft(node);
    if (balance > 1 && id > node->left->id) {
        node->left = rotateLeft(node->left);
        return rotateRight(node);
    }
    if (balance < -1 && id < node->right->id) {
        node->right = rotateRight(node->right);
        return rotateLeft(node);
    }
    return node;
}

// Parcourir et imprimer les résultats void traverseAndPrint(AVLNode *root, FILE *output) {
    if (root) {
        traverseAndPrint(root->left, output);
        fprintf(output, "%d:%d:%d\n", root->id, root->capacity, root->consumption);
        traverseAndPrint(root->right, output);
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    FILE *output = fopen(argv[2], "w");
    if (!input || !output) {
        perror("Erreur d'ouverture de fichier");
        return 1;
    }

    AVLNode *root = NULL;
    char line[256];
    while (fgets(line, sizeof(line), input)) {
        int id, capacity, consumption;
        if (sscanf(line, "%d:%d:%d", &id, &capacity, &consumption) == 3) {
            root = insertNode(root, id, capacity, consumption);
        }
    }
    traverseAndPrint(root, output);
    fclose(input);
    fclose(output);
    return 0;
}
