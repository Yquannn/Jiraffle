-- Ads Service Database Schema
-- Initial schema for ads service microservice

-- ==========================================
-- Campaigns Table
-- ==========================================
CREATE TABLE campaigns (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL,
    budget DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_created_by ON campaigns(created_by);
CREATE INDEX idx_campaigns_created_at ON campaigns(created_at);

-- ==========================================
-- Ads Table
-- ==========================================
CREATE TABLE ads (
    id BIGSERIAL PRIMARY KEY,
    campaign_id BIGINT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    content TEXT NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    impressions BIGINT DEFAULT 0,
    clicks BIGINT DEFAULT 0,
    conversions BIGINT DEFAULT 0,
    spend DECIMAL(10, 2) DEFAULT 0,
    target_audience VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_ads_campaign_id ON ads(campaign_id);
CREATE INDEX idx_ads_status ON ads(status);
CREATE INDEX idx_ads_created_at ON ads(created_at);

-- ==========================================
-- Ad Placements Table
-- ==========================================
CREATE TABLE ad_placements (
    id BIGSERIAL PRIMARY KEY,
    ad_id BIGINT NOT NULL REFERENCES ads(id) ON DELETE CASCADE,
    placement_location VARCHAR(100) NOT NULL,
    placement_type VARCHAR(50) NOT NULL,
    display_duration_seconds INT DEFAULT 30,
    frequency INT DEFAULT 1,
    status VARCHAR(50) NOT NULL,
    impressions BIGINT DEFAULT 0,
    clicks BIGINT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ad_placements_ad_id ON ad_placements(ad_id);
CREATE INDEX idx_ad_placements_status ON ad_placements(status);

-- ==========================================
-- Ad Performance Metrics Table
-- ==========================================
CREATE TABLE ad_performance (
    id BIGSERIAL PRIMARY KEY,
    ad_id BIGINT NOT NULL REFERENCES ads(id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    impressions BIGINT DEFAULT 0,
    clicks BIGINT DEFAULT 0,
    conversions BIGINT DEFAULT 0,
    ctr DECIMAL(5, 2) DEFAULT 0,
    spend DECIMAL(10, 2) DEFAULT 0,
    cpc DECIMAL(10, 2) DEFAULT 0,
    revenue DECIMAL(10, 2) DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ad_id, metric_date)
);

CREATE INDEX idx_ad_performance_ad_id ON ad_performance(ad_id);
CREATE INDEX idx_ad_performance_metric_date ON ad_performance(metric_date);

-- ==========================================
-- Targeting Rules Table
-- ==========================================
CREATE TABLE targeting_rules (
    id BIGSERIAL PRIMARY KEY,
    campaign_id BIGINT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    rule_type VARCHAR(100) NOT NULL,
    rule_value VARCHAR(255) NOT NULL,
    operator VARCHAR(50) NOT NULL,
    priority INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_targeting_rules_campaign_id ON targeting_rules(campaign_id);
CREATE INDEX idx_targeting_rules_active ON targeting_rules(active);

-- ==========================================
-- Ad Budget Allocation Table
-- ==========================================
CREATE TABLE budget_allocations (
    id BIGSERIAL PRIMARY KEY,
    campaign_id BIGINT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
    allocated_amount DECIMAL(10, 2) NOT NULL,
    spent_amount DECIMAL(10, 2) DEFAULT 0,
    remaining_amount DECIMAL(10, 2) NOT NULL,
    allocation_date DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_budget_allocations_campaign_id ON budget_allocations(campaign_id);
CREATE INDEX idx_budget_allocations_allocation_date ON budget_allocations(allocation_date);
