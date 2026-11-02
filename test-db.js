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
})

await client.$disconnect();