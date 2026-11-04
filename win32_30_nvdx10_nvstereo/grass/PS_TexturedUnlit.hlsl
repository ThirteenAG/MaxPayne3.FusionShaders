sampler2D DiffuseSampler : register(s0);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	r0.x = i.texcoord1.w;
	r0.y = i.texcoord2.w;
	r0 = tex2D(DiffuseSampler, r0.xy);
	r1 = i.texcoord.xyz;
	r1 = r1.xyz * -r0.xyz + i.texcoord3.xyz;
	r0 = r0 * i.texcoord;
	r0.xyz = i.texcoord3.www * r1.xyz + r0.xyz;
	o.w = r0.w;
	o.xyz = r0.xyz * globalScalars.yyy;

	return o;
}
