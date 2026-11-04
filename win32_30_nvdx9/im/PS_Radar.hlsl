sampler2D AlphaMaskMapSampler : register(s3);
sampler2D DiffuseSampler : register(s1);
float4 SubViewportParams : register(c204);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0 = r0 * i.color;
	o.xyz = r0.xyz * globalScalars.yyy;
	r0.x = r0.w * globalScalars.x;
	r0.yz = -SubViewportParams.xy + i.vpos.xy;
	r1.x = 1 / SubViewportParams.z;
	r1.y = 1 / SubViewportParams.w;
	r0.yz = r0.yz * r1.xy;
	r1 = tex2D(AlphaMaskMapSampler, r0.yz);
	o.w = r0.x * r1.w;

	return o;
}
