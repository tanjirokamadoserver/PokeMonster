-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 23-Dez-2024 às 17:44
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `monster`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `password` char(40) NOT NULL,
  `secret` char(16) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 1,
  `premdays` int(11) NOT NULL DEFAULT 0,
  `lastday` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL DEFAULT '',
  `creation` int(11) NOT NULL DEFAULT 0,
  `pontos` int(11) NOT NULL DEFAULT 0,
  `creationIp` varchar(255) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `accounts`
-----------------------------------------------

--
-- Estrutura da tabela `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expired_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `notify` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `blocked_ips`
--

CREATE TABLE `blocked_ips` (
  `id` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 0,
  `bloqueado` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bonificacoes`
--

CREATE TABLE `bonificacoes` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `valorMin` int(11) NOT NULL,
  `valorMax` int(11) NOT NULL,
  `porcentagem` int(11) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `boss_ranking`
--

CREATE TABLE `boss_ranking` (
  `classificacao` int(11) NOT NULL,
  `player` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_categoria_wiki`
--

CREATE TABLE `config_categoria_wiki` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_inicio`
--

CREATE TABLE `config_inicio` (
  `id` int(11) NOT NULL,
  `pc` text DEFAULT NULL,
  `mobile32` text DEFAULT NULL,
  `mobile64` text DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `regras` longtext DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_bazar`
--

CREATE TABLE `config_permission_bazar` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_bonificacao`
--

CREATE TABLE `config_permission_bonificacao` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_inicio`
--

CREATE TABLE `config_permission_inicio` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_noticia`
--

CREATE TABLE `config_permission_noticia` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_pacotes`
--

CREATE TABLE `config_permission_pacotes` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) DEFAULT 'F',
  `ler` varchar(1) DEFAULT 'F',
  `atualizar` varchar(1) DEFAULT 'F',
  `deletar` varchar(1) DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_promocional`
--

CREATE TABLE `config_permission_promocional` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_push`
--

CREATE TABLE `config_permission_push` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_quests`
--

CREATE TABLE `config_permission_quests` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_team`
--

CREATE TABLE `config_permission_team` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_permission_wiki`
--

CREATE TABLE `config_permission_wiki` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_promocional`
--

CREATE TABLE `config_promocional` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `name_account` varchar(255) NOT NULL,
  `apelido` varchar(255) DEFAULT NULL,
  `porcentagem` int(11) NOT NULL,
  `codigo` text NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp(),
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_quests`
--

CREATE TABLE `config_quests` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `storage` text NOT NULL,
  `name` varchar(255) NOT NULL,
  `descricao` text DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_team`
--

CREATE TABLE `config_team` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `apelido` varchar(50) NOT NULL,
  `cargo` varchar(50) NOT NULL,
  `imutavel` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_vocations`
--

CREATE TABLE `config_vocations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `id_vocation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_wiki`
--

CREATE TABLE `config_wiki` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `categoria_id` int(11) NOT NULL,
  `titulo` text NOT NULL,
  `corpo` longtext NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `download`
--

CREATE TABLE `download` (
  `id` int(11) NOT NULL,
  `pc` text NOT NULL,
  `mobile` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `global_storage`
--

CREATE TABLE `global_storage` (
  `key` int(10) UNSIGNED NOT NULL,
  `value` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `global_storage`
--

INSERT INTO `global_storage` (`key`, `value`) VALUES
(1, '1');

-- --------------------------------------------------------

--
-- Estrutura da tabela `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `buffs` blob DEFAULT NULL,
  `wars_won` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `wars_lost` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `join_status` tinyint(4) NOT NULL DEFAULT 1,
  `language` tinyint(4) NOT NULL DEFAULT 1,
  `required_level` int(11) NOT NULL DEFAULT 1,
  `emblem` int(11) NOT NULL DEFAULT 1,
  `pacifism` bigint(20) NOT NULL DEFAULT 0,
  `pacifism_status` tinyint(4) NOT NULL DEFAULT 0,
  `buffs_save` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `guilds`
--

INSERT INTO `guilds` (`id`, `name`, `ownerid`, `creationdata`, `level`, `gold`, `buffs`, `wars_won`, `wars_lost`, `motd`, `join_status`, `language`, `required_level`, `emblem`, `pacifism`, `pacifism_status`, `buffs_save`) VALUES
(1, 'Teste', 1, 1725378695, 6, 210000, 0x020202000000000000, 0, 0, '', 1, 1, 50, 0, 0, 0, 1731803288182);

--
-- Acionadores `guilds`
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
-- Estrutura da tabela `guilds_inbox`
--

CREATE TABLE `guilds_inbox` (
  `id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` bigint(20) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `guilds_inbox`
--

INSERT INTO `guilds_inbox` (`id`, `target_id`, `guild_id`, `date`, `type`, `text`, `finished`) VALUES
(1, 0, 0, 1727322665, 6, 'Teste deposited {10000}.', 0),
(2, 0, 0, 1730251379, 5, 'Guild {Brave} has been disbanded by the leader.', 0),
(3, 0, 0, 1730251395, 6, 'Teste deposited {20000}.', 0),
(4, 0, 0, 1731438079, 6, 'Icaro deposited {9990000}.', 0),
(5, 0, 0, 1731803331, 6, 'Icaro deposited {10000}.', 0),
(6, 0, 0, 1732044084, 6, 'Teste deposited {9990000}.', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `guilds_inbox_old`
--

CREATE TABLE `guilds_inbox_old` (
  `player_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` bigint(20) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guilds_player_inbox`
--

CREATE TABLE `guilds_player_inbox` (
  `player_id` int(11) NOT NULL,
  `inbox_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `guilds_player_inbox`
--

INSERT INTO `guilds_player_inbox` (`player_id`, `inbox_id`) VALUES
(1, 4),
(1, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `guildwar_kills`
--

CREATE TABLE `guildwar_kills` (
  `id` int(11) NOT NULL,
  `warid` int(11) NOT NULL DEFAULT 0,
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int(11) NOT NULL DEFAULT 0,
  `targetguild` int(11) NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_invites`
--

CREATE TABLE `guild_invites` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_members`
--

CREATE TABLE `guild_members` (
  `player_id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT '',
  `leader` tinyint(4) NOT NULL DEFAULT 0,
  `contribution` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `guild_members`
--

INSERT INTO `guild_members` (`player_id`, `guild_id`, `rank_id`, `nick`, `leader`, `contribution`) VALUES
(1, 1, 1, '', 1, 10000);

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `permissions` int(11) NOT NULL DEFAULT 0,
  `default` tinyint(4) NOT NULL DEFAULT 0,
  `leader` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `guild_ranks`
--

INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `permissions`, `default`, `leader`) VALUES
(1, 1, 'the Leader', -1, 0, 1),
(2, 1, 'a Member', 0, 1, 0),
(7, 1, 'Membro Novo', 34, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int(11) NOT NULL,
  `guild1` int(11) NOT NULL DEFAULT 0,
  `guild2` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `goldBet` int(11) NOT NULL DEFAULT 0,
  `duration` bigint(20) NOT NULL DEFAULT 0,
  `killsMax` int(11) NOT NULL DEFAULT 0,
  `forced` tinyint(4) NOT NULL DEFAULT 0,
  `started` bigint(20) NOT NULL DEFAULT 0,
  `ended` bigint(20) NOT NULL DEFAULT 0,
  `winner` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `historico_bazar`
--

CREATE TABLE `historico_bazar` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `account_id_comprador` int(11) NOT NULL,
  `account_id_vendedor` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `pix` varchar(1) NOT NULL DEFAULT 'F',
  `pago_comprador` varchar(1) NOT NULL DEFAULT 'F',
  `pago_vendedor` varchar(1) NOT NULL DEFAULT 'F',
  `status_pagamento` int(11) DEFAULT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `historico_mp`
--

CREATE TABLE `historico_mp` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `account_id` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `multiplicador` int(11) NOT NULL DEFAULT 1,
  `promocional_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` date DEFAULT NULL,
  `create_admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Acionadores `historico_mp`
--
DELIMITER $$
CREATE TRIGGER `set_date_created` BEFORE INSERT ON `historico_mp` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `historico_mp_shop`
--

CREATE TABLE `historico_mp_shop` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `account_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Acionadores `historico_mp_shop`
--
DELIMITER $$
CREATE TRIGGER `set_date_created_historico_mp_shop` BEFORE INSERT ON `historico_mp_shop` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `historico_pagamentos`
--

CREATE TABLE `historico_pagamentos` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `tipo` varchar(255) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `id_pacote` int(11) DEFAULT NULL,
  `multiplicador` decimal(5,1) NOT NULL DEFAULT 1.0,
  `promocional_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `entregue` int(11) NOT NULL DEFAULT 0,
  `qrcode` mediumtext DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `paid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `warnings` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `rent` int(11) NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 0,
  `bid` int(11) NOT NULL DEFAULT 0,
  `bid_end` int(11) NOT NULL DEFAULT 0,
  `last_bid` int(11) NOT NULL DEFAULT 0,
  `highest_bidder` int(11) NOT NULL DEFAULT 0,
  `size` int(11) NOT NULL DEFAULT 0,
  `beds` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `houses`
--

INSERT INTO `houses` (`id`, `owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `beds`) VALUES
(1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 178, 0),
(2, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 207, 0),
(3, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(4, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 181, 0),
(5, 0, 0, 0, '5', 0, 1, 0, 0, 0, 0, 119, 0),
(6, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(7, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(8, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(9, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 83, 0),
(10, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(11, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 82, 0),
(12, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(13, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(14, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(15, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(16, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(17, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 131, 0),
(18, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 155, 0),
(19, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 200, 0),
(20, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 196, 0),
(21, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 195, 0),
(22, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(23, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 188, 0),
(24, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 154, 0),
(25, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(26, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(27, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 68, 0),
(28, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 88, 0),
(29, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 74, 0),
(30, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 82, 0),
(31, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(32, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(33, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, 0),
(34, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(35, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 50, 0),
(36, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(37, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 454, 0),
(38, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 448, 0),
(39, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(40, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(41, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(42, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(43, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(44, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 79, 0),
(45, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, 0),
(46, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, 0),
(47, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(48, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 191, 0),
(49, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(50, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 158, 0),
(51, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, 0),
(52, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 22, 0),
(53, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 38, 0),
(54, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 35, 0),
(55, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 27, 0),
(56, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, 0),
(57, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 46, 0),
(58, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(61, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 57, 0),
(62, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(63, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 264, 0),
(64, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 144, 0),
(65, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 494, 0),
(66, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(67, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(68, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, 0),
(69, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 69, 0),
(70, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 192, 0),
(71, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 306, 0),
(72, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 238, 0),
(73, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 320, 0),
(74, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 238, 0),
(75, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 223, 0),
(76, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 182, 0),
(77, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, 0),
(78, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 39, 0),
(79, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 576, 0),
(80, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(81, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 295, 0),
(82, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 124, 0),
(83, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 144, 0),
(84, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 108, 0),
(85, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 103, 0),
(86, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 97, 0),
(87, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 106, 0),
(88, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(89, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(90, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 217, 0),
(91, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 201, 0),
(92, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 204, 0),
(93, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, 0),
(94, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 353, 0),
(95, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 133, 0),
(96, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, 0),
(97, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 167, 0),
(98, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 0),
(99, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 163, 0),
(100, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 97, 0),
(101, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(102, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 178, 0),
(103, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, 0),
(104, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(105, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 173, 0),
(106, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 177, 0),
(107, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 164, 0),
(108, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(109, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, 0),
(110, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 152, 0),
(111, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 224, 0),
(112, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, 0),
(113, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 86, 0),
(114, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(115, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 124, 0),
(116, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(117, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 102, 0),
(118, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, 0),
(119, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 0),
(120, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 96, 0),
(121, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(122, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 67, 0),
(123, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(124, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(125, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 244, 0),
(126, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 173, 0),
(127, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 197, 0),
(128, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 168, 1),
(129, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 399, 1),
(130, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 1),
(131, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 189, 1),
(132, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 243, 1),
(133, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 216, 1),
(134, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 1),
(135, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 1),
(136, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 100, 0),
(137, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 118, 1),
(138, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(139, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 154, 0),
(140, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(141, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 166, 0),
(142, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(143, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(144, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 73, 0),
(145, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(146, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, 0),
(147, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(148, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 110, 0),
(149, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 111, 0),
(150, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 126, 0),
(151, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 109, 0),
(152, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(153, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, 0),
(156, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 0),
(157, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(158, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(159, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 69, 0),
(160, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 169, 0),
(161, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 38, 0),
(162, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 0),
(163, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 93, 1),
(164, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, 1),
(165, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 43, 1),
(166, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 1),
(167, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, 1),
(168, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 68, 1),
(169, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 171, 1),
(170, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 156, 1),
(171, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 160, 1),
(172, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 91, 1),
(173, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 117, 1),
(174, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, 2),
(175, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 122, 2),
(176, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 253, 2),
(177, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 92, 1),
(178, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 116, 0),
(179, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 153, 0),
(180, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 340, 0),
(181, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(182, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 103, 0),
(183, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 76, 0),
(184, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 102, 0),
(185, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 75, 0),
(186, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 0),
(187, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(188, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(189, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 185, 0),
(191, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(192, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 73, 0),
(193, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 53, 0),
(194, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(195, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(196, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, 0),
(197, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 143, 0),
(198, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 168, 0),
(199, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, 0),
(200, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(201, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 27, 0),
(202, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(203, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, 0),
(204, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(205, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 32, 0),
(206, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 279, 0),
(207, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, 0),
(208, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, 0),
(209, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 366, 0),
(210, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 403, 0),
(211, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 402, 0),
(212, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(213, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 224, 0),
(214, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 18, 0),
(215, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 18, 0),
(216, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, 0),
(217, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(218, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 326, 0),
(219, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 160, 0),
(220, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 267, 0),
(221, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 275, 0),
(222, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 33, 0),
(223, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, 0),
(224, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 143, 0),
(225, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 234, 0),
(226, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(227, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 115, 0),
(228, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 259, 0),
(229, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 169, 0),
(230, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(231, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(232, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(233, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 157, 0),
(234, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 215, 0),
(235, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 228, 0),
(236, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(237, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, 0),
(238, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, 0),
(239, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(240, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 165, 0),
(241, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 433, 0),
(242, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 311, 0),
(243, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 411, 0),
(244, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 278, 0),
(245, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(246, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(247, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(248, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(249, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(251, 0, 0, 0, 'House #2', 0, 3, 0, 0, 0, 0, 56, 0),
(252, 0, 0, 0, 'House #3', 0, 3, 0, 0, 0, 0, 61, 0),
(253, 0, 0, 0, 'Ceu House #1', 0, 17, 0, 0, 0, 0, 70, 0),
(254, 0, 0, 0, 'Ceu House #2', 0, 17, 0, 0, 0, 0, 72, 0),
(255, 0, 0, 0, 'Ceu House #3', 0, 17, 0, 0, 0, 0, 192, 0),
(256, 0, 0, 0, 'Ceu House #4', 0, 17, 0, 0, 0, 0, 192, 0),
(257, 0, 0, 0, 'Ceu House #5', 0, 17, 0, 0, 0, 0, 208, 0),
(258, 0, 0, 0, 'Ceu House #6', 0, 17, 0, 0, 0, 0, 144, 0),
(259, 0, 0, 0, 'Ceu House #7', 0, 17, 0, 0, 0, 0, 141, 0),
(260, 0, 0, 0, 'Ceu House #8', 0, 17, 0, 0, 0, 0, 141, 0),
(261, 0, 0, 0, 'Ceu House #9', 0, 17, 0, 0, 0, 0, 105, 0),
(262, 0, 0, 0, 'Ceu House #10', 0, 17, 0, 0, 0, 0, 147, 0),
(263, 0, 0, 0, 'Ceu House #11', 0, 17, 0, 0, 0, 0, 181, 0),
(264, 0, 0, 0, 'Ceu House #12', 0, 17, 0, 0, 0, 0, 116, 0),
(265, 0, 0, 0, 'Ceu House #13', 0, 17, 0, 0, 0, 0, 82, 0),
(266, 0, 0, 0, 'Ceu House #14', 0, 17, 0, 0, 0, 0, 163, 0),
(267, 0, 0, 0, 'Ceu House #15', 0, 17, 0, 0, 0, 0, 190, 0),
(268, 0, 0, 0, 'Ceu House #16', 0, 17, 0, 0, 0, 0, 77, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(11) NOT NULL,
  `listid` int(11) NOT NULL,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int(10) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_history`
--

CREATE TABLE `market_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT 0,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `inserted` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `created` bigint(20) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `currency` int(11) NOT NULL DEFAULT 0,
  `attributes` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Estrutura da tabela `noticias`
--

CREATE TABLE `noticias` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `titulo` text NOT NULL,
  `texto` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_update` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pacotes`
--

CREATE TABLE `pacotes` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `id_item_pacote` int(11) NOT NULL,
  `cor_pacote` varchar(100) NOT NULL,
  `caminho_tag` varchar(255) DEFAULT NULL,
  `caminho_itens` longtext DEFAULT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `valor_cortado` decimal(10,2) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_update` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `cod` varchar(1000) NOT NULL,
  `method` varchar(200) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` float(9,2) DEFAULT NULL,
  `delivery` int(11) NOT NULL DEFAULT 0 COMMENT '0,1',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mercadopago` int(11) NOT NULL DEFAULT 0,
  `bank_transfer` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pix_payment`
--

CREATE TABLE `pix_payment` (
  `player_id` int(11) NOT NULL,
  `loc_id` int(11) NOT NULL,
  `txid` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `creation` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT 1,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 500,
  `vocation` int(11) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `health` int(11) NOT NULL DEFAULT 150,
  `healthmax` int(11) NOT NULL DEFAULT 150,
  `experience` bigint(20) NOT NULL DEFAULT 13752,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 510,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `mana` int(11) NOT NULL DEFAULT 0,
  `manamax` int(11) NOT NULL DEFAULT 0,
  `manaspent` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `soul` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 13,
  `posx` int(11) NOT NULL DEFAULT 54,
  `posy` int(11) NOT NULL DEFAULT 449,
  `posz` int(11) NOT NULL DEFAULT 5,
  `conditions` blob DEFAULT NULL,
  `cap` int(11) NOT NULL DEFAULT 6,
  `sex` int(11) NOT NULL DEFAULT 0,
  `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `lastip` varchar(255) DEFAULT NULL,
  `save` tinyint(1) NOT NULL DEFAULT 1,
  `skull` tinyint(1) NOT NULL DEFAULT 0,
  `skulltime` int(11) NOT NULL DEFAULT 0,
  `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `blessings` tinyint(4) NOT NULL DEFAULT 0,
  `onlinetime` int(11) DEFAULT 0,
  `deletion` bigint(20) NOT NULL DEFAULT 0,
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT 43200,
  `offlinetraining_skill` int(11) NOT NULL DEFAULT -1,
  `stamina` smallint(5) UNSIGNED NOT NULL DEFAULT 2520,
  `skill_fist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_club` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_club_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_sword` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_sword_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_axe` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_axe_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_dist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_dist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_shielding` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_shielding_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_fishing` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fishing_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `pokemons` varchar(2000) NOT NULL DEFAULT '',
  `creationdate` int(11) DEFAULT NULL,
  `lookaura` int(11) NOT NULL DEFAULT 0,
  `lookwings` int(11) NOT NULL DEFAULT 0,
  `lookshader` int(11) NOT NULL DEFAULT 0,
  `diamond` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `players`
--

--
-- Acionadores `players`
--
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players_online`
--

CREATE TABLE `players_online` (
  `player_id` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players_stringstorages`
--

CREATE TABLE `players_stringstorages` (
  `player_id` int(11) NOT NULL,
  `key` int(11) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `players_stringstorages`
--

INSERT INTO `players_stringstorages` (`player_id`, `key`, `value`) VALUES
(1, 750000, 'crafts');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_deaths`
--

CREATE TABLE `player_deaths` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT 1,
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT 0,
  `unjustified` tinyint(1) NOT NULL DEFAULT 0,
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `pid` int(11) NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL DEFAULT 0,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(5, 2, 101, 2580, 1, ''),
(5, 3, 102, 1987, 1, 0x2300),
(5, 7, 103, 2382, 1, ''),
(5, 8, 104, 7731, 1, ''),
(5, 9, 105, 2270, 1, ''),
(5, 102, 106, 26738, 1, ''),
(1, 2, 101, 2580, 1, ''),
(1, 3, 102, 1987, 1, 0x2300),
(1, 7, 103, 2382, 1, ''),
(1, 8, 104, 7731, 1, ''),
(1, 9, 105, 2270, 1, ''),
(1, 102, 106, 26677, 1, 0x2db2285f67000000002e06000000000000000b0069736265696e67757365640200000000000000000b00706f6b656c6f6f6b6469720203000000000000000a00706f6b656865616c746802217500000000000008006c6f6f6b7479706502d4030000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d65010d007368696e79206e6f63746f776c),
(1, 102, 107, 26677, 1, 0x2e06000000000000000b0069736265696e67757365640200000000000000000b00706f6b656c6f6f6b6469720201000000000000000a00706f6b656865616c746802633700000000000008006c6f6f6b74797065022f030000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650107006e6f63746f776c),
(1, 102, 108, 40609, 1, 0x240100),
(1, 102, 109, 26677, 1, 0x2e0e000000000000000a00706f6b656865616c74680352b81e852b40e0400b0069736265696e67757365640200000000000000000b00706f6b656c6f6f6b6469720200000000000000000300636436024d255f670000000003006364350242255f670000000003006364320238255f6700000000030063643102201e5f67000000000300636433023d1e5f67000000000800706f6b656e616d650106006c61707261730300636438023f1e5f67000000000900706f6b65626f6f737402000000000000000008006c6f6f6b747970650283000000000000000300636434024c1e5f67000000000300636437023a1e5f6700000000),
(1, 102, 110, 26738, 1, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint(20) NOT NULL,
  `namelocked_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_seller`
--

CREATE TABLE `player_seller` (
  `id` int(11) NOT NULL,
  `account_seller` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `pix_blocked` varchar(1) NOT NULL DEFAULT 'F',
  `date_pix_blocked` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `key` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `value` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(1, 5009, 1),
(1, 10002, 1),
(1, 71344, 36),
(1, 72703, 45),
(1, 395000, 1),
(1, 604000, 0),
(1, 764003, 1),
(1, 764007, 4),
(1, 870006, 1),
(1, 870010, 1),
(1, 870016, 1),
(1, 870022, 1),
(1, 870045, 1),
(1, 870065, 1),
(1, 870069, 1),
(1, 870094, 1),
(1, 870114, 1),
(1, 870131, 1),
(1, 870649, 1),
(1, 1980000, 1732591862),
(5, 5009, 1),
(5, 71344, 0),
(5, 72703, 3),
(5, 604000, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `pokeball_stats`
--

CREATE TABLE `pokeball_stats` (
  `player_id` int(11) NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `poke` int(11) NOT NULL DEFAULT 0,
  `great` int(11) NOT NULL DEFAULT 0,
  `ultra` int(11) NOT NULL DEFAULT 0,
  `saffari` int(11) NOT NULL DEFAULT 0,
  `master` int(11) NOT NULL DEFAULT 0,
  `moon` int(11) NOT NULL DEFAULT 0,
  `tinker` int(11) NOT NULL DEFAULT 0,
  `sora` int(11) NOT NULL DEFAULT 0,
  `dusk` int(11) NOT NULL DEFAULT 0,
  `yume` int(11) NOT NULL DEFAULT 0,
  `tale` int(11) NOT NULL DEFAULT 0,
  `net` int(11) NOT NULL DEFAULT 0,
  `janguru` int(11) NOT NULL DEFAULT 0,
  `magu` int(11) NOT NULL DEFAULT 0,
  `fast` int(11) NOT NULL DEFAULT 0,
  `heavy` int(11) NOT NULL DEFAULT 0,
  `premier` int(11) NOT NULL DEFAULT 0,
  `delta` int(11) NOT NULL DEFAULT 0,
  `esferadepal` int(11) NOT NULL DEFAULT 0,
  `esferamega` int(11) NOT NULL DEFAULT 0,
  `esferagiga` int(11) NOT NULL DEFAULT 0,
  `esferatera` int(11) NOT NULL DEFAULT 0,
  `esferaultra` int(11) NOT NULL DEFAULT 0,
  `esferalendaria` int(11) NOT NULL DEFAULT 0,
  `super` int(11) NOT NULL DEFAULT 0,
  `especial` int(11) NOT NULL DEFAULT 0,
  `divine` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pokemon_points`
--

CREATE TABLE `pokemon_points` (
  `player_id` int(11) NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `pontos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `push`
--

CREATE TABLE `push` (
  `id` int(11) NOT NULL,
  `create_admin_id` int(11) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `mensagem` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `redeem_codes`
--

CREATE TABLE `redeem_codes` (
  `id` int(11) NOT NULL,
  `serial` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `max_uses` int(11) DEFAULT NULL,
  `total_used` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Extraindo dados da tabela `server_config`
--

INSERT INTO `server_config` (`config`, `value`) VALUES
('motd_hash', 'a6afd77936a557689fc7902fc7a227c78df6fb55'),
('motd_num', '2'),
('players_record', '2');

-- --------------------------------------------------------

--
-- Estrutura da tabela `shop_historico`
--

CREATE TABLE `shop_historico` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `shop_item_id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `desconto` int(11) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `entregue` int(11) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `shop_history`
--

CREATE TABLE `shop_history` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `title` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `target` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `shop_image`
--

CREATE TABLE `shop_image` (
  `id` int(11) NOT NULL,
  `shop_item_id` int(11) NOT NULL,
  `tipo` int(11) NOT NULL DEFAULT 1,
  `caminho` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `shop_item`
--

CREATE TABLE `shop_item` (
  `id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `created_admin_id` int(11) DEFAULT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `categoria_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `maximo` int(11) DEFAULT NULL,
  `descricao` text NOT NULL,
  `desconto` int(11) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `suporte`
--

CREATE TABLE `suporte` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `image1` text DEFAULT NULL,
  `image2` text DEFAULT NULL,
  `titulo` varchar(50) NOT NULL,
  `descricao` varchar(200) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` datetime NOT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `suporte_respostas`
--

CREATE TABLE `suporte_respostas` (
  `id` int(11) NOT NULL,
  `suporte_id` int(11) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `resposta` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int(11) NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tokenvalidat`
--

CREATE TABLE `tokenvalidat` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `expired` varchar(1) DEFAULT 'F',
  `validation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `verificar_callback`
--

CREATE TABLE `verificar_callback` (
  `id` int(11) NOT NULL,
  `passou` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices para tabela `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices para tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices para tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_player_index` (`account_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices para tabela `blocked_ips`
--
ALTER TABLE `blocked_ips`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `bonificacoes`
--
ALTER TABLE `bonificacoes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `boss_ranking`
--
ALTER TABLE `boss_ranking`
  ADD PRIMARY KEY (`classificacao`,`player`);

--
-- Índices para tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_inicio`
--
ALTER TABLE `config_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_push`
--
ALTER TABLE `config_permission_push`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_team`
--
ALTER TABLE `config_permission_team`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_promocional`
--
ALTER TABLE `config_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_quests`
--
ALTER TABLE `config_quests`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_team`
--
ALTER TABLE `config_team`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_vocations`
--
ALTER TABLE `config_vocations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `config_wiki`
--
ALTER TABLE `config_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `download`
--
ALTER TABLE `download`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `key` (`key`);

--
-- Índices para tabela `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `ownerid` (`ownerid`);

--
-- Índices para tabela `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD KEY `player_id` (`player_id`);

--
-- Índices para tabela `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `inbox_id` (`inbox_id`);

--
-- Índices para tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Índices para tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`) USING BTREE,
  ADD KEY `player_id` (`player_id`,`guild_id`) USING BTREE;

--
-- Índices para tabela `guild_members`
--
ALTER TABLE `guild_members`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `guild_id` (`guild_id`),
  ADD KEY `rank_id` (`rank_id`);

--
-- Índices para tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices para tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild1` (`guild1`),
  ADD KEY `guild2` (`guild2`),
  ADD KEY `winner` (`winner`);

--
-- Índices para tabela `historico_bazar`
--
ALTER TABLE `historico_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `historico_mp`
--
ALTER TABLE `historico_mp`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`),
  ADD KEY `town_id` (`town_id`);

--
-- Índices para tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD KEY `house_id` (`house_id`);

--
-- Índices para tabela `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Índices para tabela `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`,`sale`);

--
-- Índices para tabela `market_offers`
--
ALTER TABLE `market_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale` (`itemtype`),
  ADD KEY `created` (`created`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices para tabela `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `pacotes`
--
ALTER TABLE `pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `pix_payment`
--
ALTER TABLE `pix_payment`
  ADD UNIQUE KEY `txid` (`txid`),
  ADD UNIQUE KEY `loc` (`loc_id`);

--
-- Índices para tabela `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Índices para tabela `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Índices para tabela `players_stringstorages`
--
ALTER TABLE `players_stringstorages`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Índices para tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `killed_by` (`killed_by`),
  ADD KEY `mostdamage_by` (`mostdamage_by`);

--
-- Índices para tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Índices para tabela `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Índices para tabela `player_items`
--
ALTER TABLE `player_items`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Índices para tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Índices para tabela `player_seller`
--
ALTER TABLE `player_seller`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD KEY `player_id` (`player_id`);

--
-- Índices para tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Índices para tabela `pokeball_stats`
--
ALTER TABLE `pokeball_stats`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Índices para tabela `pokemon_points`
--
ALTER TABLE `pokemon_points`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Índices para tabela `push`
--
ALTER TABLE `push`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `redeem_codes`
--
ALTER TABLE `redeem_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`,`player_id`);

--
-- Índices para tabela `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Índices para tabela `shop_historico`
--
ALTER TABLE `shop_historico`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `shop_history`
--
ALTER TABLE `shop_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`),
  ADD KEY `player` (`player`);

--
-- Índices para tabela `shop_image`
--
ALTER TABLE `shop_image`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `shop_item`
--
ALTER TABLE `shop_item`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `suporte`
--
ALTER TABLE `suporte`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `tile_store`
--
ALTER TABLE `tile_store`
  ADD KEY `house_id` (`house_id`);

--
-- Índices para tabela `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `verificar_callback`
--
ALTER TABLE `verificar_callback`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `blocked_ips`
--
ALTER TABLE `blocked_ips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `bonificacoes`
--
ALTER TABLE `bonificacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_inicio`
--
ALTER TABLE `config_inicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_push`
--
ALTER TABLE `config_permission_push`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_team`
--
ALTER TABLE `config_permission_team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_promocional`
--
ALTER TABLE `config_promocional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_quests`
--
ALTER TABLE `config_quests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_team`
--
ALTER TABLE `config_team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_vocations`
--
ALTER TABLE `config_vocations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `config_wiki`
--
ALTER TABLE `config_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `download`
--
ALTER TABLE `download`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_bazar`
--
ALTER TABLE `historico_bazar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_mp`
--
ALTER TABLE `historico_mp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;

--
-- AUTO_INCREMENT de tabela `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT de tabela `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pacotes`
--
ALTER TABLE `pacotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `player_seller`
--
ALTER TABLE `player_seller`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `push`
--
ALTER TABLE `push`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_historico`
--
ALTER TABLE `shop_historico`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_history`
--
ALTER TABLE `shop_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_image`
--
ALTER TABLE `shop_image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `shop_item`
--
ALTER TABLE `shop_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suporte`
--
ALTER TABLE `suporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `verificar_callback`
--
ALTER TABLE `verificar_callback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_ban_history_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD CONSTRAINT `guilds_inbox_old_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD CONSTRAINT `guilds_player_inbox_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guilds_player_inbox_ibfk_2` FOREIGN KEY (`inbox_id`) REFERENCES `guilds_inbox` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_ibfk_1` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_members`
--
ALTER TABLE `guild_members`
  ADD CONSTRAINT `guild_members_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_3` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`);

--
-- Limitadores para a tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD CONSTRAINT `guild_wars_ibfk_1` FOREIGN KEY (`guild1`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_2` FOREIGN KEY (`guild2`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_3` FOREIGN KEY (`winner`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_ibfk_1` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_ibfk_2` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `shop_history`
--
ALTER TABLE `shop_history`
  ADD CONSTRAINT `shop_history_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shop_history_ibfk_2` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
