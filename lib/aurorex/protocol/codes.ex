defmodule Aurorex.Protocol.Codes do
  def get_code(:shutdown),                          do: 1
  def get_code(:connect),                           do: 2
  def get_code(:db_open),                           do: 3
  def get_code(:db_create),                         do: 4
  def get_code(:db_exist),                          do: 6
  def get_code(:db_drop),                           do: 7
  def get_code(:config_get),                        do: 70
  def get_code(:config_set),                        do: 71
  def get_code(:config_list),                       do: 72
  def get_code(:db_list),                           do: 74
  def get_code(:db_close),                          do: 5
  def get_code(:db_size),                           do: 8
  def get_code(:db_countrecords),                   do: 9
  def get_code(:record_load),                       do: 30
  def get_code(:record_load_if_version_not_latest), do: 44
  def get_code(:record_create),                     do: 31
  def get_code(:record_update),                     do: 32
  def get_code(:record_delete),                     do: 33
  def get_code(:record_copy),                       do: 34
  def get_code(:positions_floor),                   do: 39
  def get_code(:command),                           do: 41
  def get_code(:positions_ceiling),                 do: 42
  def get_code(:tx_commit),                         do: 60
  def get_code(:index_get),                         do: 60
  def get_code(:index_put),                         do: 60
  def get_code(:index_remove),                      do: 60
  def get_code(:db_reload),                         do: 73
  def get_code(:push_record),                       do: 79
  def get_code(:push_distrib_config),               do: 80
  def get_code(:push_live_query),                   do: 81
  def get_code(:replication),                       do: 91
  def get_code(:db_transfer),                       do: 93
  def get_code(:db_freeze),                         do: 94
  def get_code(:db_release),                        do: 95
  def get_code(:create_sbtree_bonsai),              do: 110
  def get_code(:sbtree_bonsai_get),                 do: 111
  def get_code(:sbtree_bonsai_first_key),           do: 112
  def get_code(:sbtree_bonsai_get_entries_major),   do: 113
  def get_code(:ridbag_get_size),                   do: 114
end