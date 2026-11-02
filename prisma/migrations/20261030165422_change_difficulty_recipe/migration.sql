/*
  Warnings:

  - You are about to drop the column `status` on the `recipe` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `recipe` DROP COLUMN `status`,
    ADD COLUMN `difficulty` ENUM('LOW', 'MEDIUM', 'HARD') NOT NULL DEFAULT 'MEDIUM';
