-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 03/03/2025 às 08:54
-- Versão do servidor: 8.0.41-0ubuntu0.20.04.1
-- Versão do PHP: 7.4.3-4ubuntu2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `22`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `accounts`
--

CREATE TABLE `accounts` (
  `id` int NOT NULL,
  `name` varchar(32) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `password` char(40) NOT NULL,
  `secret` char(16) DEFAULT NULL,
  `type` int NOT NULL DEFAULT '1',
  `premdays` int NOT NULL DEFAULT '0',
  `lastday` int UNSIGNED NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `creation` int NOT NULL DEFAULT '0',
  `pontos` int NOT NULL DEFAULT '0',
  `creationIp` varchar(255) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int UNSIGNED NOT NULL,
  `account_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expired_at` bigint NOT NULL,
  `banned_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `notify` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `blocked_ips`
--

CREATE TABLE `blocked_ips` (
  `id` int NOT NULL,
  `ip` varchar(45) NOT NULL,
  `timestamp` int NOT NULL,
  `quantidade` int NOT NULL DEFAULT '0',
  `bloqueado` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bonificacoes`
--

CREATE TABLE `bonificacoes` (
  `id` int NOT NULL,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `valorMin` int NOT NULL,
  `valorMax` int NOT NULL,
  `porcentagem` int NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_updated` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `boss_ranking`
--

CREATE TABLE `boss_ranking` (
  `classificacao` int NOT NULL,
  `player` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `id` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_categoria_wiki`
--

CREATE TABLE `config_categoria_wiki` (
  `id` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_inicio`
--

CREATE TABLE `config_inicio` (
  `id` int NOT NULL,
  `pc` text,
  `mobile32` text,
  `mobile64` text,
  `discord` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `regras` longtext,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_bazar`
--

CREATE TABLE `config_permission_bazar` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_bonificacao`
--

CREATE TABLE `config_permission_bonificacao` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_inicio`
--

CREATE TABLE `config_permission_inicio` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_noticia`
--

CREATE TABLE `config_permission_noticia` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_pacotes`
--

CREATE TABLE `config_permission_pacotes` (
  `id` int NOT NULL,
  `criar` varchar(1) DEFAULT 'F',
  `ler` varchar(1) DEFAULT 'F',
  `atualizar` varchar(1) DEFAULT 'F',
  `deletar` varchar(1) DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_promocional`
--

CREATE TABLE `config_permission_promocional` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_push`
--

CREATE TABLE `config_permission_push` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_quests`
--

CREATE TABLE `config_permission_quests` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_team`
--

CREATE TABLE `config_permission_team` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_permission_wiki`
--

CREATE TABLE `config_permission_wiki` (
  `id` int NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_promocional`
--

CREATE TABLE `config_promocional` (
  `id` int NOT NULL,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `name_account` varchar(255) NOT NULL,
  `apelido` varchar(255) DEFAULT NULL,
  `porcentagem` int NOT NULL,
  `codigo` text NOT NULL,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_updated` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_quests`
--

CREATE TABLE `config_quests` (
  `id` int NOT NULL,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `storage` text NOT NULL,
  `name` varchar(255) NOT NULL,
  `descricao` text,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_updated` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_team`
--

CREATE TABLE `config_team` (
  `id` int NOT NULL,
  `id_account` int NOT NULL,
  `apelido` varchar(50) NOT NULL,
  `cargo` varchar(50) NOT NULL,
  `imutavel` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_vocations`
--

CREATE TABLE `config_vocations` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_vocation` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `config_wiki`
--

CREATE TABLE `config_wiki` (
  `id` int NOT NULL,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `categoria_id` int NOT NULL,
  `titulo` text NOT NULL,
  `corpo` longtext NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_updated` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `download`
--

CREATE TABLE `download` (
  `id` int NOT NULL,
  `pc` text NOT NULL,
  `mobile` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `global_storage`
--

CREATE TABLE `global_storage` (
  `key` int UNSIGNED NOT NULL,
  `value` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds`
--

CREATE TABLE `guilds` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `ownerid` int NOT NULL,
  `creationdata` bigint UNSIGNED NOT NULL DEFAULT '0',
  `level` int UNSIGNED NOT NULL DEFAULT '1',
  `gold` bigint UNSIGNED NOT NULL DEFAULT '0',
  `buffs` blob,
  `wars_won` int UNSIGNED NOT NULL DEFAULT '0',
  `wars_lost` int UNSIGNED NOT NULL DEFAULT '0',
  `motd` varchar(255) NOT NULL DEFAULT '',
  `join_status` tinyint NOT NULL DEFAULT '1',
  `language` tinyint NOT NULL DEFAULT '1',
  `required_level` int NOT NULL DEFAULT '1',
  `emblem` int NOT NULL DEFAULT '1',
  `pacifism` bigint NOT NULL DEFAULT '0',
  `pacifism_status` tinyint NOT NULL DEFAULT '0',
  `buffs_save` bigint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Gatilhos `guilds`
--
DELIMITER $$
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds` FOR EACH ROW BEGIN
		INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `leader`) VALUES ('the Leader', -1, NEW.`id`, 1);
		INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `default`) VALUES ('a Member', 0, NEW.`id`, 1);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds_inbox`
--

CREATE TABLE `guilds_inbox` (
  `id` int NOT NULL,
  `target_id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL DEFAULT '0',
  `date` bigint UNSIGNED NOT NULL,
  `type` tinyint NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds_inbox_old`
--

CREATE TABLE `guilds_inbox_old` (
  `player_id` int NOT NULL,
  `target_id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL DEFAULT '0',
  `date` bigint UNSIGNED NOT NULL,
  `type` tinyint NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds_player_inbox`
--

CREATE TABLE `guilds_player_inbox` (
  `player_id` int NOT NULL,
  `inbox_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guildwar_kills`
--

CREATE TABLE `guildwar_kills` (
  `id` int NOT NULL,
  `warid` int NOT NULL DEFAULT '0',
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int NOT NULL DEFAULT '0',
  `targetguild` int NOT NULL DEFAULT '0',
  `time` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_invites`
--

CREATE TABLE `guild_invites` (
  `id` int NOT NULL,
  `player_id` int NOT NULL DEFAULT '0',
  `guild_id` int NOT NULL DEFAULT '0',
  `date` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_members`
--

CREATE TABLE `guild_members` (
  `player_id` int NOT NULL,
  `guild_id` int NOT NULL,
  `rank_id` int NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT '',
  `leader` tinyint NOT NULL DEFAULT '0',
  `contribution` bigint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int NOT NULL,
  `guild_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `permissions` int NOT NULL DEFAULT '0',
  `default` tinyint NOT NULL DEFAULT '0',
  `leader` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int NOT NULL,
  `guild1` int NOT NULL DEFAULT '0',
  `guild2` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '0',
  `goldBet` int NOT NULL DEFAULT '0',
  `duration` bigint NOT NULL DEFAULT '0',
  `killsMax` int NOT NULL DEFAULT '0',
  `forced` tinyint NOT NULL DEFAULT '0',
  `started` bigint NOT NULL DEFAULT '0',
  `ended` bigint NOT NULL DEFAULT '0',
  `winner` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_bazar`
--

CREATE TABLE `historico_bazar` (
  `id` int NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `account_id_comprador` int NOT NULL,
  `account_id_vendedor` int NOT NULL,
  `char_id` int NOT NULL,
  `valor` int NOT NULL,
  `pix` varchar(1) NOT NULL DEFAULT 'F',
  `pago_comprador` varchar(1) NOT NULL DEFAULT 'F',
  `pago_vendedor` varchar(1) NOT NULL DEFAULT 'F',
  `status_pagamento` int DEFAULT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_mp`
--

CREATE TABLE `historico_mp` (
  `id` int NOT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `account_id` int NOT NULL,
  `valor` int NOT NULL,
  `multiplicador` int NOT NULL DEFAULT '1',
  `promocional_id` int DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `date_created` date DEFAULT NULL,
  `create_admin_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gatilhos `historico_mp`
--
DELIMITER $$
CREATE TRIGGER `set_date_created` BEFORE INSERT ON `historico_mp` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_mp_shop`
--

CREATE TABLE `historico_mp_shop` (
  `id` int NOT NULL,
  `payment_id` varchar(250) NOT NULL,
  `shop_id` int NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `account_id` int NOT NULL,
  `player_id` int NOT NULL,
  `item_id_tibia` int DEFAULT NULL,
  `type` int NOT NULL,
  `quantidade` int NOT NULL,
  `valor` int NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `date_created` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gatilhos `historico_mp_shop`
--
DELIMITER $$
CREATE TRIGGER `set_date_created_historico_mp_shop` BEFORE INSERT ON `historico_mp_shop` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_pagamentos`
--

CREATE TABLE `historico_pagamentos` (
  `id` int NOT NULL,
  `payment_id` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `account_id` int NOT NULL,
  `player_id` int DEFAULT NULL,
  `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor` int NOT NULL,
  `id_pacote` int DEFAULT NULL,
  `multiplicador` decimal(5,1) NOT NULL DEFAULT '1.0',
  `promocional_id` int DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `entregue` int NOT NULL DEFAULT '0',
  `qrcode` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `houses`
--

CREATE TABLE `houses` (
  `id` int NOT NULL,
  `owner` int NOT NULL,
  `paid` int UNSIGNED NOT NULL DEFAULT '0',
  `warnings` int NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `rent` int NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '0',
  `bid` int NOT NULL DEFAULT '0',
  `bid_end` int NOT NULL DEFAULT '0',
  `last_bid` int NOT NULL DEFAULT '0',
  `highest_bidder` int NOT NULL DEFAULT '0',
  `size` int NOT NULL DEFAULT '0',
  `beds` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int NOT NULL,
  `listid` int NOT NULL,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint NOT NULL,
  `expires_at` bigint NOT NULL,
  `banned_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `market_history`
--

CREATE TABLE `market_history` (
  `id` int UNSIGNED NOT NULL,
  `player_id` int NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT '0',
  `itemtype` int UNSIGNED NOT NULL,
  `amount` smallint UNSIGNED NOT NULL,
  `price` int UNSIGNED NOT NULL DEFAULT '0',
  `expires_at` bigint UNSIGNED NOT NULL,
  `inserted` bigint UNSIGNED NOT NULL,
  `state` tinyint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int UNSIGNED NOT NULL,
  `player_id` int NOT NULL,
  `itemtype` int UNSIGNED NOT NULL,
  `amount` smallint UNSIGNED NOT NULL,
  `created` bigint UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `price` bigint UNSIGNED NOT NULL DEFAULT '0',
  `currency` int NOT NULL DEFAULT '0',
  `attributes` blob
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `noticias`
--

CREATE TABLE `noticias` (
  `id` int NOT NULL,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `titulo` text NOT NULL,
  `texto` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP,
  `date_update` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pacotes`
--

CREATE TABLE `pacotes` (
  `id` int NOT NULL,
  `nome` varchar(255) NOT NULL,
  `id_item_pacote` int NOT NULL,
  `cor_pacote` varchar(100) NOT NULL,
  `caminho_tag` varchar(255) DEFAULT NULL,
  `caminho_itens` longtext,
  `created_admin_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `valor_cortado` decimal(10,2) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `payments`
--

CREATE TABLE `payments` (
  `id` int NOT NULL,
  `account_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `cod` varchar(1000) NOT NULL,
  `method` varchar(200) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` float(9,2) DEFAULT NULL,
  `delivery` int NOT NULL DEFAULT '0' COMMENT '0,1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mercadopago` int NOT NULL DEFAULT '0',
  `bank_transfer` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pix_payment`
--

CREATE TABLE `pix_payment` (
  `player_id` int NOT NULL,
  `loc_id` int NOT NULL,
  `txid` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `paid` tinyint(1) NOT NULL DEFAULT '0',
  `creation` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players`
--

CREATE TABLE `players` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int NOT NULL DEFAULT '1',
  `account_id` int NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '500',
  `vocation` int NOT NULL DEFAULT '0',
  `image` text,
  `health` int NOT NULL DEFAULT '150',
  `healthmax` int NOT NULL DEFAULT '150',
  `experience` bigint NOT NULL DEFAULT '13752',
  `lookbody` int NOT NULL DEFAULT '0',
  `lookfeet` int NOT NULL DEFAULT '0',
  `lookhead` int NOT NULL DEFAULT '0',
  `looklegs` int NOT NULL DEFAULT '0',
  `looktype` int NOT NULL DEFAULT '510',
  `lookaddons` int NOT NULL DEFAULT '0',
  `maglevel` int NOT NULL DEFAULT '0',
  `mana` int NOT NULL DEFAULT '0',
  `manamax` int NOT NULL DEFAULT '0',
  `manaspent` int UNSIGNED NOT NULL DEFAULT '0',
  `soul` int UNSIGNED NOT NULL DEFAULT '0',
  `town_id` int NOT NULL DEFAULT '13',
  `posx` int NOT NULL DEFAULT '54',
  `posy` int NOT NULL DEFAULT '449',
  `posz` int NOT NULL DEFAULT '5',
  `conditions` blob,
  `cap` int NOT NULL DEFAULT '6',
  `sex` int NOT NULL DEFAULT '0',
  `lastlogin` bigint UNSIGNED NOT NULL DEFAULT '0',
  `lastip` varchar(255) DEFAULT NULL,
  `save` tinyint(1) NOT NULL DEFAULT '1',
  `skull` tinyint(1) NOT NULL DEFAULT '0',
  `skulltime` int NOT NULL DEFAULT '0',
  `lastlogout` bigint UNSIGNED NOT NULL DEFAULT '0',
  `blessings` tinyint NOT NULL DEFAULT '0',
  `onlinetime` int DEFAULT '0',
  `deletion` bigint NOT NULL DEFAULT '0',
  `balance` bigint UNSIGNED NOT NULL DEFAULT '0',
  `offlinetraining_time` smallint UNSIGNED NOT NULL DEFAULT '43200',
  `offlinetraining_skill` int NOT NULL DEFAULT '-1',
  `stamina` smallint UNSIGNED NOT NULL DEFAULT '2520',
  `skill_fist` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_fist_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_club` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_club_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_sword` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_sword_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_axe` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_axe_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_dist` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_dist_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_shielding` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_shielding_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `skill_fishing` int UNSIGNED NOT NULL DEFAULT '10',
  `skill_fishing_tries` bigint UNSIGNED NOT NULL DEFAULT '0',
  `pokemons` varchar(2000) NOT NULL DEFAULT '',
  `creationdate` int DEFAULT NULL,
  `lookaura` int NOT NULL DEFAULT '0',
  `lookwings` int NOT NULL DEFAULT '0',
  `lookshader` int NOT NULL DEFAULT '0',
  `diamond` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Gatilhos `players`
--
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players_online`
--

CREATE TABLE `players_online` (
  `player_id` int NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players_stringstorages`
--

CREATE TABLE `players_stringstorages` (
  `player_id` int NOT NULL,
  `key` int NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_deaths`
--

CREATE TABLE `player_deaths` (
  `player_id` int NOT NULL,
  `time` bigint UNSIGNED NOT NULL DEFAULT '0',
  `level` int NOT NULL DEFAULT '1',
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT '1',
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT '0',
  `unjustified` tinyint(1) NOT NULL DEFAULT '0',
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` mediumint NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int NOT NULL,
  `sid` int NOT NULL,
  `pid` int NOT NULL DEFAULT '0',
  `itemtype` mediumint NOT NULL,
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int NOT NULL DEFAULT '0',
  `pid` int NOT NULL DEFAULT '0',
  `sid` int NOT NULL DEFAULT '0',
  `itemtype` mediumint NOT NULL DEFAULT '0',
  `count` smallint NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint NOT NULL,
  `namelocked_by` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_seller`
--

CREATE TABLE `player_seller` (
  `id` int NOT NULL,
  `account_seller` int NOT NULL,
  `char_id` int NOT NULL,
  `price` int NOT NULL,
  `pix_blocked` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'F',
  `date_pix_blocked` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int NOT NULL DEFAULT '0',
  `key` int UNSIGNED NOT NULL DEFAULT '0',
  `value` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pokeball_stats`
--

CREATE TABLE `pokeball_stats` (
  `player_id` int NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `poke` int NOT NULL DEFAULT '0',
  `great` int NOT NULL DEFAULT '0',
  `ultra` int NOT NULL DEFAULT '0',
  `saffari` int NOT NULL DEFAULT '0',
  `master` int NOT NULL DEFAULT '0',
  `moon` int NOT NULL DEFAULT '0',
  `tinker` int NOT NULL DEFAULT '0',
  `sora` int NOT NULL DEFAULT '0',
  `dusk` int NOT NULL DEFAULT '0',
  `yume` int NOT NULL DEFAULT '0',
  `tale` int NOT NULL DEFAULT '0',
  `net` int NOT NULL DEFAULT '0',
  `janguru` int NOT NULL DEFAULT '0',
  `magu` int NOT NULL DEFAULT '0',
  `fast` int NOT NULL DEFAULT '0',
  `heavy` int NOT NULL DEFAULT '0',
  `premier` int NOT NULL DEFAULT '0',
  `delta` int NOT NULL DEFAULT '0',
  `esferadepal` int NOT NULL DEFAULT '0',
  `esferamega` int NOT NULL DEFAULT '0',
  `esferagiga` int NOT NULL DEFAULT '0',
  `esferatera` int NOT NULL DEFAULT '0',
  `esferaultra` int NOT NULL DEFAULT '0',
  `esferalendaria` int NOT NULL DEFAULT '0',
  `super` int NOT NULL DEFAULT '0',
  `especial` int NOT NULL DEFAULT '0',
  `divine` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pokemon_points`
--

CREATE TABLE `pokemon_points` (
  `player_id` int NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `pontos` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `push`
--

CREATE TABLE `push` (
  `id` int NOT NULL,
  `create_admin_id` int NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `mensagem` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `redeem_codes`
--

CREATE TABLE `redeem_codes` (
  `id` int NOT NULL,
  `serial` text,
  `type` text,
  `player_id` int DEFAULT NULL,
  `max_uses` int DEFAULT NULL,
  `total_used` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shop_historico`
--

CREATE TABLE `shop_historico` (
  `id` int NOT NULL,
  `account_id` int NOT NULL,
  `player_id` int NOT NULL,
  `shop_item_id` int NOT NULL,
  `item_id_tibia` int DEFAULT NULL,
  `type` int NOT NULL,
  `quantidade` int NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `desconto` int DEFAULT NULL,
  `valor` int NOT NULL,
  `entregue` int NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shop_history`
--

CREATE TABLE `shop_history` (
  `id` int NOT NULL,
  `account` int NOT NULL,
  `player` int NOT NULL,
  `date` datetime NOT NULL,
  `title` varchar(100) NOT NULL,
  `price` int NOT NULL,
  `count` int NOT NULL DEFAULT '0',
  `target` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shop_image`
--

CREATE TABLE `shop_image` (
  `id` int NOT NULL,
  `shop_item_id` int NOT NULL,
  `tipo` int NOT NULL DEFAULT '1',
  `caminho` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shop_item`
--

CREATE TABLE `shop_item` (
  `id` int NOT NULL,
  `item_id_tibia` int DEFAULT NULL,
  `created_admin_id` int DEFAULT NULL,
  `update_admin_id` int DEFAULT NULL,
  `categoria_id` int NOT NULL,
  `type` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `quantidade` int NOT NULL,
  `maximo` int DEFAULT NULL,
  `descricao` text NOT NULL,
  `desconto` int DEFAULT NULL,
  `valor` int NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `suporte`
--

CREATE TABLE `suporte` (
  `id` int NOT NULL,
  `account_id` int NOT NULL,
  `update_admin_id` int DEFAULT NULL,
  `image1` text,
  `image2` text,
  `titulo` varchar(50) NOT NULL,
  `descricao` varchar(200) NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `date_created` datetime NOT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `suporte_respostas`
--

CREATE TABLE `suporte_respostas` (
  `id` int NOT NULL,
  `suporte_id` int NOT NULL,
  `account_id` int DEFAULT NULL,
  `admin_id` int DEFAULT NULL,
  `resposta` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tokenvalidat`
--

CREATE TABLE `tokenvalidat` (
  `id` int NOT NULL,
  `id_account` int DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `expired` varchar(1) DEFAULT 'F',
  `validation_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `verificar_callback`
--

CREATE TABLE `verificar_callback` (
  `id` int NOT NULL,
  `passou` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Índices de tabelas apagadas
--

--
-- Índices de tabela `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_player_index` (`account_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `blocked_ips`
--
ALTER TABLE `blocked_ips`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `bonificacoes`
--
ALTER TABLE `bonificacoes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `boss_ranking`
--
ALTER TABLE `boss_ranking`
  ADD PRIMARY KEY (`classificacao`,`player`);

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_inicio`
--
ALTER TABLE `config_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_push`
--
ALTER TABLE `config_permission_push`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_team`
--
ALTER TABLE `config_permission_team`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_promocional`
--
ALTER TABLE `config_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_quests`
--
ALTER TABLE `config_quests`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_team`
--
ALTER TABLE `config_team`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_vocations`
--
ALTER TABLE `config_vocations`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `config_wiki`
--
ALTER TABLE `config_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `download`
--
ALTER TABLE `download`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `key` (`key`);

--
-- Índices de tabela `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `ownerid` (`ownerid`);

--
-- Índices de tabela `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `inbox_id` (`inbox_id`);

--
-- Índices de tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Índices de tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`) USING BTREE,
  ADD KEY `player_id` (`player_id`,`guild_id`) USING BTREE;

--
-- Índices de tabela `guild_members`
--
ALTER TABLE `guild_members`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `guild_id` (`guild_id`),
  ADD KEY `rank_id` (`rank_id`);

--
-- Índices de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices de tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild1` (`guild1`),
  ADD KEY `guild2` (`guild2`),
  ADD KEY `winner` (`winner`);

--
-- Índices de tabela `historico_bazar`
--
ALTER TABLE `historico_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `historico_mp`
--
ALTER TABLE `historico_mp`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`),
  ADD KEY `town_id` (`town_id`);

--
-- Índices de tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD KEY `house_id` (`house_id`);

--
-- Índices de tabela `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices de tabela `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`,`sale`);

--
-- Índices de tabela `market_offers`
--
ALTER TABLE `market_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale` (`itemtype`),
  ADD KEY `created` (`created`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pacotes`
--
ALTER TABLE `pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pix_payment`
--
ALTER TABLE `pix_payment`
  ADD UNIQUE KEY `txid` (`txid`),
  ADD UNIQUE KEY `loc` (`loc_id`);

--
-- Índices de tabela `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Índices de tabela `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Índices de tabela `players_stringstorages`
--
ALTER TABLE `players_stringstorages`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Índices de tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `killed_by` (`killed_by`),
  ADD KEY `mostdamage_by` (`mostdamage_by`);

--
-- Índices de tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Índices de tabela `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Índices de tabela `player_items`
--
ALTER TABLE `player_items`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Índices de tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Índices de tabela `player_seller`
--
ALTER TABLE `player_seller`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Índices de tabela `pokeball_stats`
--
ALTER TABLE `pokeball_stats`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Índices de tabela `pokemon_points`
--
ALTER TABLE `pokemon_points`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Índices de tabela `push`
--
ALTER TABLE `push`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `redeem_codes`
--
ALTER TABLE `redeem_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`,`player_id`);

--
-- Índices de tabela `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Índices de tabela `shop_historico`
--
ALTER TABLE `shop_historico`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `shop_history`
--
ALTER TABLE `shop_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`),
  ADD KEY `player` (`player`);

--
-- Índices de tabela `shop_image`
--
ALTER TABLE `shop_image`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `shop_item`
--
ALTER TABLE `shop_item`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `suporte`
--
ALTER TABLE `suporte`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `tile_store`
--
ALTER TABLE `tile_store`
  ADD KEY `house_id` (`house_id`);

--
-- Índices de tabela `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `verificar_callback`
--
ALTER TABLE `verificar_callback`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas apagadas
--

--
-- AUTO_INCREMENT de tabela `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `blocked_ips`
--
ALTER TABLE `blocked_ips`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `bonificacoes`
--
ALTER TABLE `bonificacoes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_inicio`
--
ALTER TABLE `config_inicio`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_push`
--
ALTER TABLE `config_permission_push`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_team`
--
ALTER TABLE `config_permission_team`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_promocional`
--
ALTER TABLE `config_promocional`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_quests`
--
ALTER TABLE `config_quests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_team`
--
ALTER TABLE `config_team`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_vocations`
--
ALTER TABLE `config_vocations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_wiki`
--
ALTER TABLE `config_wiki`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `download`
--
ALTER TABLE `download`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_bazar`
--
ALTER TABLE `historico_bazar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_mp`
--
ALTER TABLE `historico_mp`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pacotes`
--
ALTER TABLE `pacotes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `players`
--
ALTER TABLE `players`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `player_seller`
--
ALTER TABLE `player_seller`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `push`
--
ALTER TABLE `push`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_historico`
--
ALTER TABLE `shop_historico`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_history`
--
ALTER TABLE `shop_history`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_image`
--
ALTER TABLE `shop_image`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_item`
--
ALTER TABLE `shop_item`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suporte`
--
ALTER TABLE `suporte`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `verificar_callback`
--
ALTER TABLE `verificar_callback`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Restrições para dumps de tabelas
--

--
-- Restrições para tabelas `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_ban_history_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD CONSTRAINT `guilds_inbox_old_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD CONSTRAINT `guilds_player_inbox_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guilds_player_inbox_ibfk_2` FOREIGN KEY (`inbox_id`) REFERENCES `guilds_inbox` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_ibfk_1` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_members`
--
ALTER TABLE `guild_members`
  ADD CONSTRAINT `guild_members_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_3` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`);

--
-- Restrições para tabelas `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD CONSTRAINT `guild_wars_ibfk_1` FOREIGN KEY (`guild1`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_2` FOREIGN KEY (`guild2`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_3` FOREIGN KEY (`winner`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_ibfk_1` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_ibfk_2` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `shop_history`
--
ALTER TABLE `shop_history`
  ADD CONSTRAINT `shop_history_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shop_history_ibfk_2` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
