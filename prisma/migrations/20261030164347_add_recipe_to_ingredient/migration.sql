-- CreateTable
CREATE TABLE `Ingredient_Recipe` (
    `recipeId` INTEGER NOT NULL,
    `ingredientId` INTEGER NOT NULL,

    UNIQUE INDEX `Ingredient_Recipe_recipeId_ingredientId_key`(`recipeId`, `ingredientId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Ingredient_Recipe` ADD CONSTRAINT `Ingredient_Recipe_recipeId_fkey` FOREIGN KEY (`recipeId`) REFERENCES `Recipe`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Ingredient_Recipe` ADD CONSTRAINT `Ingredient_Recipe_ingredientId_fkey` FOREIGN KEY (`ingredientId`) REFERENCES `Ingredient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
