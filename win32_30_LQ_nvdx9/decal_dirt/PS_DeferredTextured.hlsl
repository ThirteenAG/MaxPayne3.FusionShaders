sampler2D DiffuseSampler : register(s0);
float3 dirtDecalMask : register(c196);
float4 globalScalars : register(c35);
float specularColorFactor : register(c198);
float specularFactor : register(c197);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyw = float3(1, 0.0051020407, 0);
	r0.y = saturate(r0.y * specularFactor.x);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.z = r0.x + -specularFactor.x;
	o.color2.y = (r0.z >= 0) ? 0.26726124 : r0.y;
	o.color.xyz = i.color.xyz;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.y = dot(r1.xyz, dirtDecalMask.xyz);
	r0.y = r0.y * i.color.w;
	r1.w = r0.y * globalScalars.x;
	o.color.w = r1.w;
	o.color1 = 0;
	r1.xz = r0.xw * specularColorFactor.xx;
	o.color2.xzw = r1.xzw;
	o.color3 = r1.zzzw;

	return o;
}
