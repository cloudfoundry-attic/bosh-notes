#!/usr/bin/env ruby

class Proposal < Struct.new(:name, :summary_kvs, :md_url)
  def state
    summary_kvs["State"]
  end
end

class ProposalCollection < Struct.new(:proposals)
  SORT_PRIORITY = {
    "in-progress" => 0,
    "discussing"  => 1,
    "accepted"    => 2,
    "finished"    => 4,
    "rejected"    => 5,
    nil           => 6, # unknown
  }

  def self.build
    proposals = []

    Dir["proposals/*.md"].each do |file|
      lines = File.read(file).split("\n")
      summary_kv_prefix = "- "

      still_summary = true
      summary_lines = lines.select { |l| still_summary &= l.start_with?(summary_kv_prefix) }

      proposals << Proposal.new.tap do |p|
        p.name = file[/\/(.*)\.md/,1]
        p.md_url = file
        p.summary_kvs = Hash[summary_lines.map { |l| l.sub(summary_kv_prefix, "").split(": ", 2) }]
      end
    end

    ProposalCollection.new(proposals)
  end

  def sorted
    proposals.group_by { |p| p.state }.sort_by { |state,_| SORT_PRIORITY[state] }.each { |_,ps| ps.sort_by!(&:name) }
  end

  def print_md
    puts "## Summary\n\n"
    sorted.each do |state, props|
      puts "## #{state}\n\n"
      props.each do |prop|
        puts "- #{prop.name}"
        puts "  - Link: [#{prop.md_url}](#{prop.md_url})"
        prop.summary_kvs.each do |k, v|
          puts "  - #{k}: #{v}"
        end
        puts ""
      end
    end
  end
end

ProposalCollection.build.print_md
