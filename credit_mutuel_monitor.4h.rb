#!/usr/bin/env ruby

# Credit Mutuel Monitor plugin for BitBar
# Yann Very <yann.very@gmail.com>
#
# Requires 'mechanize' gem
# You must set your CM username and password.
# https://www.creditmutuel.fr/fr/authentification.html
#
# <bitbar.title>CM Monitor</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Yann Very</bitbar.author>
# <bitbar.author.github>yannvery</bitbar.author.github>
# <bitbar.desc>Credit Mutuel Monitor.</bitbar.desc>
# <bitbar.dependencies>ruby,mechanize gem</bitbar.dependencies>

require 'mechanize'
require 'yaml'

class CreditMutuelMonitor
  GREEN_COLOR = '#29cc00'
  RED_COLOR = '#ff0033'
  LOGIN_URI = 'https://www.creditmutuel.fr/fr/authentification.html'
  ACCOUNTS_URI = 'https://www.creditmutuel.fr/fr/banque/comptes-et-contrats.html'

  def initialize(username, password, exclude_accounts)
    @username = username
    @password = password
    @exclude_accounts = exclude_accounts || []
    @agent = Mechanize.new
  end

  def output
    login
    output_main_status
    output_accounts_status
  end

  private

  def login
    login_form = @agent.get(LOGIN_URI).form('bloc_ident')
    login_form.field(name: '_cm_user').value = @username
    login_form.field_with(name: '_cm_pwd').value = @password
    @agent.submit(login_form)
  end

  def output_main_status
    if all_accounts_positive?
      puts '✓'
    else
      puts "Acc. ✗| color=#{RED_COLOR} "
    end
    puts '---'
  end

  def output_accounts_status
    accounts_status.each { |text| puts text }
  end

  def accounts_status
    accounts.map { |account, value| account_status(account, value) }
  end

  def account_status(account, value)
    return "#{account}: #{value} ✓" if positive_value?(value)
    details = "#{account}: #{value} ✗"
    details << "| color=#{RED_COLOR}" if not_exlude_account?(account)
    details
  end

  def not_exlude_account?(account)
    !@exclude_accounts.include?(account)
  end

  def positive_value?(value)
    value =~ /^\+.*$/
  end

  def negative_value?(value)
    !positive_value?(value)
  end

  def all_accounts_positive?
    accounts.each do |account, value|
      return false if negative_value?(value) && not_exlude_account?(account)
    end
    true
  end

  def lines_from_account_table
    @agent.get(ACCOUNTS_URI).search('table.ei_comptescontrats').search('tr')
  end

  def accounts_lines
    lines_from_account_table.select do |line|
      !line.attributes['class'].nil? &&
        line.attributes['class'].value == '_c1  _c1'
    end
  end

  def accounts
    accounts_lines.map { |l| [account_title(l), account_value(l)] }.to_h
  end

  def account_title(line)
    td_node = line.search('td')
    title_node = td_node.search('.ei_sdsf_title')
    name_node = td_node.search('span.nowrap').first
    title_node.text + ' - ' + name_node.text
  end

  def account_value(line)
    line.search('td').search('.ei_sdsf_solde').text
  end
end

params = YAML.load_file(File.dirname(__FILE__) + '/configuration.yml')['credit_mutuel']

plugin = CreditMutuelMonitor.new(
  params['username'],
  params['password'],
  params['exclude_accounts']
)

plugin.output
