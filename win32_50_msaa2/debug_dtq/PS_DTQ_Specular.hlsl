cbuffer DebugDTQ : register(b4)
{
	float4 param0 : packoffset(c0);
	float4 param1 : packoffset(c1);
	float4 param2 : packoffset(c2);
	float4 param3 : packoffset(c3);
	float4 param4 : packoffset(c4);
	float4 param5 : packoffset(c5);
	float4 param6 : packoffset(c6);
	float4 param7 : packoffset(c7);
};

SamplerState samp : register(s0);
Texture2D samp_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float3 r1;
	r0.xy = samp_tex.SampleLevel(samp, i.texcoord.xy, param5.x).xy;
	r0 = r0.xxyy * float4(2, 2, 2, 2) + float4(-1, -1, -1, -1);
	r1.x = dot(r0.yw, r0.yw);
	r0 = r0 * param6.w;
	r0 = r0 * float4(1, 0, 0, 1);
	r0.xyz = r0.zwz + r0.xyy;
	r0.w = -(r1.x) + 1;
	r0.w = max(r0.w, 0);
	r0.w = sqrt(r0.w);
	r0.xyz = r0.www * float3(0, 0, 1) + r0.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.xy = i.texcoord.xy * float2(2, 2) + float2(-1, -1);
	r1.xy = r1.xy + -(param6.xy);
	r1.xy = r1.xy + float2(0.00000999999975, 0.00000999999975);
	r1.z = param6.z + 0.00000999999975;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r1 = r0.www * r1.xyz;
	r0.x = dot(r0.xyz, r1.xyz);
	r0.y = max(r1.z, 0);
	r0.y = r0.y + 0.00000999999975;
	r0.y = log2(r0.y);
	r0.x = max(r0.x, 0);
	r0.x = r0.x + 0.00000999999975;
	r0.x = log2(r0.x);
	r0.z = param7.x + 0.00000999999975;
	r0.x = r0.x * r0.z;
	r0.x = exp2(r0.x);
	r0.z = param7.x * 8 + 0.00000999999975;
	r0.y = r0.y * r0.z;
	r0.y = exp2(r0.y);
	r0.yzw = r0.yyy * float3(0, 1, 1);
	r0.xyz = r0.xxx * param7.yyy + -(r0.yzw);
	o.xyz = max(r0.xyz, float3(0, 0, 0));
	o.w = 1;

	return o;
}
