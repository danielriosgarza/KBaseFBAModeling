#!/usr/bin/env perl
########################################################################
# Authors: Christopher Henry, Scott Devoid, Paul Frybarger
# Contact email: chenry@mcs.anl.gov
# Development location: Mathematics and Computer Science Division, Argonne National Lab
########################################################################
use strict;
use warnings;
use Bio::KBase::workspace::ScriptHelpers qw(printObjectInfo get_ws_client workspace workspaceURL parseObjectMeta parseWorkspaceMeta printObjectMeta);
use Bio::KBase::fbaModelServices::ScriptHelpers qw(fbaws get_fba_client runFBACommand universalFBAScriptCode );
#Defining globals describing behavior
my $primaryArgs = ["Template ID","Reaction ID"];
my $servercommand = "adjust_template_reaction";
my $script = "fba-adjusttemprxn";
my $translation = {
	"Template ID" => "templateModel",
	"Reaction ID" => "reaction",
	workspace => "workspace",
	compartment => "compartment",
	direction => "direction",
	type => "type",
	"new" => "new",
	"delete" => "delete",
	auth => "auth",
	clearcomplexes => "clearComplexes",
	complexestoadd => "complexesToAdd",
	complexestoremove => "complexesToRemove",
	outputid => "output_id"
};
#Defining usage and options
my $specs = [
    [ 'compartment|c=s', 'Compartment of template reaction', { "default" => "c" } ],
    [ 'direction=s', 'Direction of template reaction' ],
    [ 'type=s', 'Type of template reaction' ],
    [ 'new', 'Create new biomass reaction' ],
    [ 'delete', 'Delete specified biomass reaction' ],
    [ 'clearcomplexes', 'Clear all complexes mapped to reaction' ],
    [ 'complexestoadd=s', 'Complexes to add to reaction (; delimited)' ],
    [ 'complexestoremove=s', 'Complexes to remove from reaction (; delimited)' ],
    [ 'outputid|o=s', 'Output ID for altered template model'],
    [ 'workspace|w=s', 'Workspace to save FBA results', { "default" => fbaws() } ],
];
my ($opt,$params) = universalFBAScriptCode($specs,$script,$primaryArgs,$translation);
if (defined($opt->{complexestoadd})) {
	$params->{complexesToAdd} = [split(/;/,$opt->{complexestoadd})];
}
if (defined($opt->{complexestoremove})) {
    $params->{complexesToRemove} = [split(/;/,$opt->{complexesToRemove})];
}
#Calling the server
my $output = runFBACommand($params,$servercommand,$opt);
#Checking output and report results
if (!defined($output)) {
	print "Adjustment of template reaction failed!\n";
} else {
	print "Adjustment of template reaction successful:\n";
	printObjectInfo($output);
}