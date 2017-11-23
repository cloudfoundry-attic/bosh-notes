#!/usr/bin/env ruby

class Proposal < Struct.new(:name, :kvs, :summary, :md_url)
  def state
    kvs["State"]
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
      kv_prefix = "- "

      still_kvs = true
      kv_lines = lines.select { |l| still_kvs &= l.start_with?(kv_prefix) }

      in_summary = false
      summary_lines = lines.select do |l|
        if l == "# Summary"
          in_summary = true
          next
        elsif in_summary && l.start_with?("# ")
          in_summary = false
        end
        in_summary
      end

      proposals << Proposal.new.tap do |p|
        p.name = file[/\/(.*)\.md/,1]
        p.md_url = file
        p.summary = summary_lines.join
        p.kvs = Hash[kv_lines.map { |l| l.sub(kv_prefix, "").split(": ", 2) }]
      end
    end

    ProposalCollection.new(proposals)
  end

  def sorted
    proposals.group_by { |p| p.state }.sort_by { |state,_| SORT_PRIORITY[state] }.each { |_,ps| ps.sort_by!(&:name) }
  end

  def print_md
    puts "# Summary\n\n"
    sorted.each do |state, props|
      puts "## #{state}\n\n"
      props.each do |prop|
        puts "- [#{prop.name}](#{prop.md_url})"
        prop.kvs.each do |k, v|
          puts "  - #{k}: #{v}"
        end
        puts "  - Summary: #{prop.summary}" unless prop.summary.empty?
        puts ""
      end
    end
  end
end

ProposalCollection.build.print_md
