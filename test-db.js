import { client } from "./prisma-client.js";

const newRecipe = await client.recipe.create({
    data: {
        name: 'Spaghetti alla carbonara',
        description: 'Buonissima',
        difficulty: 'MEDIUM',
        chef: {
            create: {
                name: "Patricia Ann"
            }
        }
    }
});

const recipes = await client.recipe.findMany();
console.log(recipes);


await client.$disconnect();